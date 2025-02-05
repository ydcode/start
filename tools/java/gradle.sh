#!/bin/bash

install_gradle__debian() {
  apt update && apt install -y unzip

  if [ -d "/usr/gradle" ]; then
    rm -rf /usr/gradle
  fi

  wget https://services.gradle.org/distributions/gradle-8.8-bin.zip
  mkdir -p /usr/gradle && unzip -q gradle-8.8-bin.zip -d /usr/gradle && mv /usr/gradle/gradle-8.8/* /usr/gradle/
  grep -q "export GRADLE_HOME=/usr/gradle" /etc/profile || echo "export GRADLE_HOME=/usr/gradle" >>/etc/profile
  grep -q "\$GRADLE_HOME/bin" /etc/profile || echo "export PATH=\$GRADLE_HOME/bin:\$PATH" >>/etc/profile
  source /etc/profile
}

install_gradle() {
  if command -v gradle >/dev/null 2>&1; then
    version=$(gradle --version | grep "Gradle" | awk '{print $2}')
    echo "✅ Gradle is already installed, version: $version"
    return 0
  fi

  echo
  echo "⌛️ Starting Gradle installation..."

  install_gradle__debian

  if command -v gradle >/dev/null 2>&1; then
    version=$(gradle --version | grep "Gradle" | awk '{print $2}')
    echo "✅ Gradle installed successfully, version: $version"
  else
    echo "❌ Gradle installation failed. 'gradle' command not found."
    exit 1
  fi
}
