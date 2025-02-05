#!/bin/bash

install_docker_compose__debian() {
  COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') || {
    echo "Failed to fetch the latest Docker Compose version. Please install manually."
    return 1
  }

  sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose || {
    echo "Failed to install Docker Compose. Please install manually."
    return 1
  }
}


install_docker_compose() {
    if command -v docker-compose >/dev/null 2>&1; then
        version=$(docker-compose --version)
        echo "✅ Docker Compose is already installed, version: $version"
        return 0
    fi

    echo
    echo "⌛️ Starting Install Docker Compose..."

    install_docker_compose__debian

   if command -v docker-compose >/dev/null 2>&1; then
        version=$(docker-compose --version)
        echo "✅ Docker Compose Installed, version: $version"
    else
        echo "❌ Docker Compose installation failed."
        exit 1
    fi
}

