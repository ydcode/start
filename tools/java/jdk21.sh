#!/bin/bash

install_jdk21__debian() {
  wget https://cdn.azul.com/zulu/bin/zulu21.30.15-ca-jdk21.0.1-linux_x64.tar.gz
  mkdir -p /usr/java && tar -xzvf zulu21.30.15-ca-jdk21.0.1-linux_x64.tar.gz --strip-components 1 -C /usr/java
  grep -q "export JAVA_HOME=/usr/java" /etc/profile || echo "export JAVA_HOME=/usr/java" >>/etc/profile
  grep -q "\$JAVA_HOME/bin" /etc/profile || echo "export PATH=\$JAVA_HOME/bin:\$PATH" >>/etc/profile
  source /etc/profile
}

install_jdk21() {
  if command -v java >/dev/null 2>&1; then
    version=$(java -version 2>&1 | head -n 1)
    if echo "$version" | grep -q "21"; then
      echo "✅ JDK 21 is already installed, version: $version"
      return 0
    fi
  fi

  echo
  echo "⌛️ Starting JDK 21 installation..."

  install_jdk21__debian

  if command -v java >/dev/null 2>&1; then
    version=$(java -version 2>&1 | head -n 1)
    if echo "$version" | grep -q "21"; then
      echo "✅ JDK 21 installed successfully, version: $version"
    else
      echo "❌ JDK 21 installation failed. Detected version: $version"
      exit 1
    fi
  else
    echo "❌ JDK 21 installation failed, 'java' command not found."
    exit 1
  fi
}
