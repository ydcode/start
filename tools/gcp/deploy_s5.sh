#!/usr/bin/env bash
set -Eeuo pipefail

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
  exit 1
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

# ---- Billing & Projects preparation ----
BILLING_ACCOUNT=$(gcloud beta billing accounts list --filter="OPEN" --format="value(NAME)" | head -n1)
EXISTING=($(gcloud projects list --format="value(projectId)"))
NEED=$((3 - ${#EXISTING[@]}))
if [ $NEED -gt 0 ]; then
  for i in $(seq 1 $NEED); do
    NEW_PROJ=proj-$(openssl rand -hex 4)
    retry gcloud projects create "$NEW_PROJ" --quiet
    EXISTING+=("$NEW_PROJ")
  done
fi
PROJECTS=("${EXISTING[@]:0:3}")

# ---- Main loop per project ----
for PROJECT in "${PROJECTS[@]}"; do
  echo "===> Processing project: $PROJECT <==="

  # 1. Link billing (idempotent)
  CURRENT_BILL=$(gcloud beta billing projects describe "$PROJECT" --format="value(billingAccountName)" --quiet || echo "")
  if [ "$CURRENT_BILL" != "$BILLING_ACCOUNT" ]; then
    retry gcloud beta billing projects link "$PROJECT" --billing-account="$BILLING_ACCOUNT" --quiet
  fi

  # 2. Enable Compute API (idempotent)
  if ! gcloud services list --enabled --filter="config.name=compute.googleapis.com" --project="$PROJECT" --format="value(config.name)" | grep -q compute.googleapis.com; then
    retry gcloud services enable compute.googleapis.com --project="$PROJECT" --quiet
  fi

  # 3. Add SSH key (idempotent)
  METADATA=$(gcloud compute project-info describe --project="$PROJECT" --format="value(commonInstanceMetadata.items.ssh-keys)")
  if ! grep -F "$PUBKEY" <<<"$METADATA"; then
    retry gcloud compute project-info add-metadata --project="$PROJECT" --metadata "ssh-keys=gce:$PUBKEY gce" --quiet
  fi

  # 4. Create firewall rule (idempotent)
  if ! gcloud compute firewall-rules list --filter="name=allow-all-to-sa AND network=default" --project="$PROJECT" --format="value(name)" | grep -q allow-all-to-sa; then
    SA_EMAIL=$(gcloud iam service-accounts list --project="$PROJECT" --format="value(email)" | head -n1)
    retry gcloud compute firewall-rules create allow-all-to-sa \
      --project="$PROJECT" \
      --network=default --direction=INGRESS --action=ALLOW --rules=all \
      --source-ranges=0.0.0.0/0 --target-service-accounts="$SA_EMAIL" --quiet
  fi

  # 5. Create 4 instances per selected zone if none exist
  for ZONE in "${ZONES[@]}"; do
    existing_count=$(gcloud compute instances list --project="$PROJECT" --zones="$ZONE" \
      --filter="name~'^${INSTANCE_PREFIX}-${ZONE}-.*'" --format="value(name)" | wc -l)
    if [ "$existing_count" -eq 0 ]; then
      retry gcloud compute instances create "${INSTANCE_PREFIX}-${ZONE}" \
        --project="$PROJECT" --count=4 --zone="$ZONE" \
        --machine-type=n1-standard-1 --image-family=debian-12 --image-project=debian-cloud \
        --boot-disk-size=10GB --quiet
    fi
  done

  # 6. Wait for all instances RUNNING
  for ZONE in "${ZONES[@]}"; do
    echo "Waiting for instances in $ZONE to be RUNNING..."
    until [ "$(gcloud compute instances list --project="$PROJECT" --zones="$ZONE" \
      --filter="name~'^${INSTANCE_PREFIX}-${ZONE}-.*' AND status=RUNNING" --format="value(name)" | wc -l)" -eq 4 ]; do
      sleep 5
    done
  done

  # 7. Parallel install Docker & run gost on all VMs
  ALL_VMS=()
  for ZONE in "${ZONES[@]}"; do
    mapfile -t vms < <(gcloud compute instances list --project="$PROJECT" --zones="$ZONE" \
      --filter="name~'^${INSTANCE_PREFIX}-${ZONE}-.*'" --format="value(name)")
    for VM in "${vms[@]}"; do
      ALL_VMS+=("$VM,$ZONE")
    done
  done
  for entry in "${ALL_VMS[@]}"; do
    VMNAME=${entry%,*}
    VMZONE=${entry#*,}
    {
      retry gcloud compute ssh gce@"$VMNAME" --project="$PROJECT" --zone="$VMZONE" --quiet --command \
        "sudo apt-get update -y && sudo apt-get install -y docker.io && sudo systemctl enable docker && sudo systemctl start docker && docker run -d --name=gost -p ${GOST_PORT}:${GOST_PORT} gogost/gost -L socks5://admin:${GOST_PASSWORD}@:${GOST_PORT}"
      echo "Setup done for $VMNAME"
    } &
  done
  wait

  # 8. Collect IPs, print proxies & total
  readarray -t IPS < <(
    for ZONE in "${ZONES[@]}"; do
      gcloud compute instances list --project="$PROJECT" --zones="$ZONE" \
        --filter="name~'^${INSTANCE_PREFIX}-${ZONE}-.*'" \
        --format='value(networkInterfaces[0].accessConfigs[0].natIP)'
    done
  )
  echo "=================================="
  for ip in "${IPS[@]}"; do
    echo "GCP:SOCKS5:${ip}:${GOST_PORT}:admin:${GOST_PASSWORD}"
  done
  echo "=================================="
  echo "Total proxies: ${#IPS[@]}"
done
