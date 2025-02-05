#!/bin/bash
CURRENT_DIR=$(pwd)
GLIDER_VERSION="0.16.3"
GLIDER_DIR="${CURRENT_DIR}/glider_${GLIDER_VERSION}_linux_amd64"
GLIDER_FILE="${CURRENT_DIR}/glider_${GLIDER_VERSION}_linux_amd64.tar.gz"
GLIDER_URL="https://github.com/nadoo/glider/releases/download/v${GLIDER_VERSION}/glider_${GLIDER_VERSION}_linux_amd64.tar.gz"
CONFIG_FILE="${CURRENT_DIR}/glider_config.json"
GLIDER_LISTEN_PORT=10888

check_pkg_manager() {
  if [ -x "$(command -v apt-get)" ]; then
    PKG_MANAGER="apt-get"
  elif [ -x "$(command -v yum)" ]; then
    PKG_MANAGER="yum"
  else
    echo "Neither apt-get nor yum found. Exiting."
    exit 1
  fi
}

install_required_cmds() {
  for cmd in jq wget curl lsof; do
    if ! [ -x "$(command -v $cmd)" ]; then
      echo "Installing missing command: $cmd"
      sudo ${PKG_MANAGER} update -y
      sudo ${PKG_MANAGER} install ${cmd} -y
    fi
  done
}

generate_random_string() {
  tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 20 | head -n 1
}

install_glider() {
  check_pkg_manager
  install_required_cmds
  echo "====== Starting glider installation/start ======"

  if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Configuration file not found. Attempting to kill processes using port ${GLIDER_LISTEN_PORT}..."
    sudo kill $(lsof -t -i:${GLIDER_LISTEN_PORT}) 2>/dev/null
  fi

  if [ -f "${GLIDER_FILE}" ]; then
    rm -f "${GLIDER_FILE}"
  fi

  if [ ! -x "${GLIDER_DIR}/glider" ]; then
    echo "Glider binary not found. Downloading and extracting..."
    wget --header="Cache-Control: no-cache" -O "${GLIDER_FILE}" "${GLIDER_URL}" || {
      echo "wget download failed. Exiting."
      exit 1
    }
    tar -xvf "${GLIDER_FILE}" -C "${CURRENT_DIR}" || {
      echo "tar extraction failed. Exiting."
      exit 1
    }
  fi

  PUBLIC_IP=$(curl -s https://checkip.amazonaws.com) || {
    echo "Failed to obtain public IP via curl. Exiting."
    exit 1
  }

  if [ -f "${CONFIG_FILE}" ]; then
    echo "Configuration file found. Reading configuration:"
    cat "${CONFIG_FILE}" | jq || {
      echo "jq parsing of configuration file failed. Exiting."
      exit 1
    }
    if ! lsof -i :${GLIDER_LISTEN_PORT} >/dev/null; then
      echo "Glider is not running. Starting glider..."
      PASSWORD=$(jq -r '.password' "${CONFIG_FILE}")
      nohup "${GLIDER_DIR}/glider" -listen socks5://admin:${PASSWORD}@localhost:${GLIDER_LISTEN_PORT} >/dev/null 2>&1 &
    fi
  else
    echo "Configuration file not found. Starting glider for the first time..."
    RANDOM_STRING=$(generate_random_string)
    nohup "${GLIDER_DIR}/glider" -listen socks5://admin:${RANDOM_STRING}@localhost:${GLIDER_LISTEN_PORT} >/dev/null 2>&1 &
    echo -n "{\"type\":\"socks5\",\"IP\":\"${PUBLIC_IP}\",\"port\":${GLIDER_LISTEN_PORT},\"username\":\"admin\",\"password\":\"${RANDOM_STRING}\"}" >"${CONFIG_FILE}"
    echo "========================================================================"
    cat "${CONFIG_FILE}" | jq || {
      echo "jq parsing of configuration file failed. Exiting."
      exit 1
    }
    echo "========================================================================"
  fi

  if lsof -i :${GLIDER_LISTEN_PORT} >/dev/null; then
    echo "✅ Glider is running."
  else
    echo "❌ Glider failed to start."
  fi

  [ -f "${GLIDER_FILE}" ] && rm -f "${GLIDER_FILE}"

  echo "====== Glider installation/start finished ======"
}

