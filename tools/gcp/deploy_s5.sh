#!/usr/bin/env bash
set -Euo pipefail   # 修改：去掉 -e，不要在错误时自动退出

# ---- retry function ----
retry(){
  local n=0 max=3 delay=5
  until [ $n -ge $max ]; do
    "$@" && return 0
    n=$((n+1))
    echo "Command failed, retry $n/$max after $delay seconds..."
    sleep $delay
  done
  echo "Command '$*' failed after $max attempts."
  return 1    # 修改：改为 return，避免退出整个脚本
}

# ---- SSH key setup ----
if [ ! -f ~/.ssh/google_compute_engine ]; then
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/google_compute_engine -N "" -q
fi
PUBKEY=$(<~/.ssh/google_compute_engine.pub)

# ---- User prompts ----
DEFAULT_PREFIX="s5"; read -e -p "Enter INSTANCE_PREFIX [default: $DEFAULT_PREFIX]: " INSTANCE_PREFIX; INSTANCE_PREFIX=${INSTANCE_PREFIX:-$DEFAULT_PREFIX}
DEFAULT_PASSWORD=$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c30)
read -e -p "Enter GOST_PASSWORD [default: $DEFAULT_PASSWORD]: " GOST_PASSWORD; GOST_PASSWORD=${GOST_PASSWORD:-$DEFAULT_PASSWORD}
DEFAULT_PORT=10888; read -e -p "Enter GOST_PORT [default: $DEFAULT_PORT]: " GOST_PORT; GOST_PORT=${GOST_PORT:-$DEFAULT_PORT}

# ---- Determine valid US zones that support n1-standard-1 ----
ALL_ZONES=( $(gcloud compute zones list --filter="region:us-*" --format="value(name)") )
VALID_ZONES=()
for Z in "${ALL_ZONES[@]}"; do
  if gcloud compute zones describe "$Z" --format="value(status)" | grep -qx UP \
     && gcloud compute machine-types list --zones="$Z" --filter="name=n1-standard-1" --format="value(name)" | grep -qx n1-standard-1; then
    VALID_ZONES+=("$Z")
  fi
done

# ---- Pick 3 random zones from VALID_ZONES ----
mapfile -t SHUFFLED_ZONES < <(printf "%s\n" "${VALID_ZONES[@]}" | shuf)
ZONES=("${SHUFFLED_ZONES[@]:0:3}")

# ---- Billing & Project preparation ----
PROJECT="${DEVSHELL_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null)}"
if [ -z "$PROJECT" ] || [ "$PROJECT" == "(unset)" ]; then
  echo "ERROR: 未检测到项目ID，请通过 'gcloud config set project' 设置，或在 Cloud Shell 中运行。"
  exit 1
fi
echo ">> Using project: $PROJECT"

# ---- Main for single project ----
echo "===> Processing project: $PROJECT <==="

# 1. Link billing (idempotent)
BILLING_ACCOUNT=$(gcloud beta billing accounts list --filter="OPEN" --format="value(NAME)" | head -n1 || true)
if [ -n "$BILLING_ACCOUNT" ]; then
  CURRENT_BILL=$(gcloud beta billing projects describe "$PROJECT" --format="value(billingAccountName)" --quiet || echo "")
  if [ "$CURRENT_BILL" != "$BILLING_ACCOUNT" ]; then
    retry gcloud beta billing projects link "$PROJECT" --billing-account="$BILLING_ACCOUNT" --quiet || true
  fi
else
  echo "WARNING: 未找到开放计费账户，跳过计费关联"
fi

# 2. Enable Compute API (idempotent)
if ! gcloud services list --enabled --filter="config.name=compute.googleapis.com" --project="$PROJECT" --format="value(config.name)" | grep -q compute.googleapis.com; then
  retry gcloud services enable compute.googleapis.com --project="$PROJECT" --quiet || true
fi

# 3. Add SSH key (idempotent)
METADATA=$(gcloud compute project-info describe --project="$PROJECT" --format="value(commonInstanceMetadata.items.ssh-keys)")
if ! grep -F "$PUBKEY" <<<"$METADATA"; then
  retry gcloud compute project-info add-metadata --project="$PROJECT" --metadata "ssh-keys=gce:$PUBKEY gce" --quiet || true
fi

# 4. Create firewall rule (idempotent)
if ! gcloud compute firewall-rules list --filter="name=allow-all-to-sa" --project="$PROJECT" --format="value(name)" | grep -q allow-all-to-sa; then
  SA_EMAIL=$(gcloud iam service-accounts list --project="$PROJECT" --format="value(email)" | head -n1)
  retry gcloud compute firewall-rules create allow-all-to-sa \
    --project="$PROJECT" \
    --network=default --direction=INGRESS --action=ALLOW --rules=all \
    --source-ranges=0.0.0.0/0 --target-service-accounts="$SA_EMAIL" --quiet || true
fi

# ---- 5. Create up to 4 instances per zone,收集创建成功的 zone ----
declare -a GOOD_ZONES=()
for ZONE in "${ZONES[@]}"; do
  echo ">>> 尝试在区域 $ZONE 创建实例"
  EXISTING_NAMES=$(gcloud compute instances list --project="$PROJECT" --zones="$ZONE" --format="value(name)" 2>/dev/null || true)
  EXISTING_COUNT=$(grep -c "^${INSTANCE_PREFIX}-${ZONE}-[0-9]\+$" <<<"$EXISTING_NAMES" || true)
  # 如果已有的少于 4 个，就补足
  if [ "$EXISTING_COUNT" -lt 4 ]; then
    success=true
    for i in $(seq $((EXISTING_COUNT+1)) 4); do
      if ! retry gcloud compute instances create "${INSTANCE_PREFIX}-${ZONE}-${i}" \
          --project="$PROJECT" --zone="$ZONE" \
          --machine-type=n1-standard-1 --image-family=debian-12 --image-project=debian-cloud \
          --boot-disk-size=10GB --quiet; then
        echo "WARNING: 在区域 $ZONE 创建实例 ${INSTANCE_PREFIX}-${ZONE}-${i} 失败，跳过此区域的后续操作"
        success=false
        break
      fi
    done
    $success && GOOD_ZONES+=("$ZONE")
  else
    echo "区域 $ZONE 已有 $EXISTING_COUNT 个实例，跳过创建"
    GOOD_ZONES+=("$ZONE")
  fi
done

# ---- 6. Wait for RUNNING，仅针对创建成功的 zones ----
for ZONE in "${GOOD_ZONES[@]}"; do
  echo "Waiting for instances in $ZONE to be RUNNING..."
  until [ "$(gcloud compute instances list --project="$PROJECT" --zones="$ZONE" --filter="status=RUNNING" --format="value(name)" | grep -c "^${INSTANCE_PREFIX}-${ZONE}-[0-9]\+$")" -eq 4 ]; do
    sleep 5
  done
done

# ---- 7. Parallel install Docker & run gost，仅针对创建成功的 zones ----
for ZONE in "${GOOD_ZONES[@]}"; do
  mapfile -t VMS < <(gcloud compute instances list --project="$PROJECT" --zones="$ZONE" --filter="status=RUNNING" --format="value(name)")
  for VM in "${VMS[@]}"; do
    {
      retry gcloud compute ssh gce@"$VM" --project="$PROJECT" --zone="$ZONE" --quiet --command \
        "sudo apt-get update -y && sudo apt-get install -y docker.io && sudo systemctl enable docker && sudo systemctl start docker && sudo docker run -d --name=gost -p ${GOST_PORT}:${GOST_PORT} gogost/gost -L socks5://admin:${GOST_PASSWORD}@:${GOST_PORT}" \
        && echo "Setup done for $VM"
    } &
  done
done
wait

# ---- 8. Collect IPs, print proxies & total ----
IPS=()
for ZONE in "${GOOD_ZONES[@]}"; do
  mapfile -t IP_LIST < <(gcloud compute instances list --project="$PROJECT" --zones="$ZONE" \
    --filter="status=RUNNING" \
    --format="csv[no-heading](name,networkInterfaces[0].accessConfigs[0].natIP)" \
    | grep "^${INSTANCE_PREFIX}-${ZONE}-" \
    | cut -d',' -f2)
  IPS+=("${IP_LIST[@]}")
done

echo "=================================="
for ip in "${IPS[@]}"; do
  echo "GCP:SOCKS5:${ip}:${GOST_PORT}:admin:${GOST_PASSWORD}"
done
echo "=================================="
echo "Total proxies: ${#IPS[@]}"
