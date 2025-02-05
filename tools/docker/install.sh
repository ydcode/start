#!/bin/bash

# 关闭并永久禁用swap的函数

# 检查swap状态并据此决定是否关闭swap的函数
check_and_disable_swap() {
  # 检查是否 vm.swappiness 已设置为 0
  if grep -q "vm.swappiness = 0" /etc/sysctl.conf; then
    print_green "vm.swappiness 已设置为 0"
  else
    disable_swap
  fi

  ulimit_value=$(ulimit -n)
  print_green "当前 ulimit -n 的值是 ${ulimit_value}"

  if [ "$ulimit_value" -lt 1000000 ]; then
    print_red "ulimit -n less than 1000000，停止执行脚本。"
    exit 1
  fi
}

# 永久设置ulimit为指定值的函数
set_ulimit_max_permanently() {
  local ulimit_file="/etc/security/limits.d/ulimit.conf"

  # 检查文件是否存在
  if [ -f "$ulimit_file" ]; then
  # 提取并打印第一个soft ulimit值
    local soft_limit=$(grep -m1 "soft nofile" $ulimit_file | awk '{ print $4 }')
    print_green "文件 $ulimit_file 已存在，将不进行修改。当前soft ulimit值为 $soft_limit"
  else
    # 写入新的配置
    echo "root soft nofile 1048576" | sudo tee -a $ulimit_file
    echo "root hard nofile 1048576" | sudo tee -a $ulimit_file

    print_green "ulimit已成功设置并存储在 $ulimit_file"
  fi
}


# 主要函数调用
set_ulimit_max_permanently
check_and_disable_swap

# Oceanbase
sed -i '/^fs.aio-max-nr\s*=.*/d' /etc/sysctl.conf
echo "fs.aio-max-nr = 1048576" >> /etc/sysctl.conf
sysctl -p


Install_JDK_DEBIAN() {
  wget https://cdn.azul.com/zulu/bin/zulu21.30.15-ca-jdk21.0.1-linux_x64.tar.gz
  mkdir -p /usr/java && tar -xzvf zulu21.30.15-ca-jdk21.0.1-linux_x64.tar.gz --strip-components 1 -C /usr/java
  grep -q "export JAVA_HOME=/usr/java" /etc/profile || echo "export JAVA_HOME=/usr/java" >> /etc/profile
  grep -q "\$JAVA_HOME/bin" /etc/profile || echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile
  source /etc/profile
}

Install_GRADLE() {
  wget https://services.gradle.org/distributions/gradle-8.8-bin.zip
  mkdir -p /usr/gradle && unzip -q gradle-8.8-bin.zip -d /usr/gradle && mv /usr/gradle/gradle-8.8/* /usr/gradle/
  grep -q "export GRADLE_HOME=/usr/gradle" /etc/profile || echo "export GRADLE_HOME=/usr/gradle" >> /etc/profile
  grep -q "\$GRADLE_HOME/bin" /etc/profile || echo "export PATH=\$GRADLE_HOME/bin:\$PATH" >> /etc/profile
  source /etc/profile
}


Install_Docker_Debian() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh
}

Install_Docker_Compose_Debian() {
  # 获取最新版本号
  COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') || {
    echo "无法获取Docker Compose的最新版本。请手动安装。"
    return 1
  }

  # 下载最新版本并添加执行权限
  sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose || {
    echo "Docker Compose安装失败。请手动安装。"
    return 1
  }

  # 显示Docker Compose版本号以验证安装
  docker-compose --version || {
    echo "Docker Compose安装验证失败。请手动检查。"
    return 1
  }

  echo "Docker Compose $COMPOSE_VERSION 安装成功。"
}

if [ ! -e "/usr/bin/docker" ]; then
  Install_Docker_Debian
fi

Install_Docker_Compose_Debian

sudo systemctl start docker
sudo systemctl enable docker #开机启动

source ~/.bashrc
docker run hello-world

