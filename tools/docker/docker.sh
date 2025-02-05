#!/bin/bash

install_docker__debian() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh

  sudo systemctl start docker
  sudo systemctl enable docker
}

install_docker() {
    if command -v docker >/dev/null 2>&1; then
        version=$(docker --version)
        echo "✅ Docker is already installed, version: $version"
        return 0
    fi

    echo
    echo "⌛️ Starting Install Docker..."

    install_docker__debian

   if command -v docker >/dev/null 2>&1; then
        version=$(docker --version)
        echo "✅ Docker Installed, version: $version"
    else
        echo "❌ Docker installation failed."
        exit 1
    fi
}

