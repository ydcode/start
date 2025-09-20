#!/bin/bash

install_jdk25__debian() {
  wget https://cdn.azul.com/zulu/bin/zulu25.28.85-ca-jdk25.0.0-linux_x64.tar.gz
  mkdir -p /usr/java && tar -xzvf zulu25.28.85-ca-jdk25.0.0-linux_x64.tar.gz --strip-components 1 -C /usr/java
  grep -q "export JAVA_HOME=/usr/java" /etc/profile || echo "export JAVA_HOME=/usr/java" >>/etc/profile
  grep -q "\$JAVA_HOME/bin" /etc/profile || echo "export PATH=\$JAVA_HOME/bin:\$PATH" >>/etc/profile
  source /etc/profile
}

install_jdk25() {
  if command -v java >/dev/null 2>&1; then
    version=$(java -version 2>&1 | head -n 1)
    if echo "$version" | grep -q "25"; then
      echo "✅ JDK 25 is already installed, version: $version"
      return 0
    fi
  fi

  echo
  echo "⌛️ Starting JDK 25 installation..."

  install_jdk25__debian

  if command -v java >/dev/null 2>&1; then
    version=$(java -version 2>&1 | head -n 1)
    if echo "$version" | grep -q "25"; then
      echo "✅ JDK 25 installed successfully, version: $version"
    else
      echo "❌ JDK 25 installation failed. Detected version: $version"
      exit 1
    fi
  else
    echo "❌ JDK 25 installation failed, 'java' command not found."
    exit 1
  fi
}
