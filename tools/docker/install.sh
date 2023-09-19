#!/bin/bash

# 定义红色打印函数
print_red() {
  local text="$1"
  echo -e "\033[31m${text}\033[0m"
}

# 定义绿色打印函数
print_green() {
  local text="$1"
  echo -e "\033[32m${text}\033[0m"
}

# 关闭并永久禁用swap的函数
disable_swap() {
  print_red "Swap已开启，正在关闭..."

#  一起执行 swapoff -a 和 swapon -a 命令是为了刷新 swap，将 swap 里的数据转储回内存，并清空 swap 里的数据。不可省略 swappiness 设置而只执行 swapoff -a；否则，重启后 swap 会再次自动打开，使得操作失效。
#  执行 sysctl -p 命令是为了在不重启的情况下使配置生效。
  grep -q "vm.swappiness = 0" /etc/sysctl.conf || echo "vm.swappiness = 0" >> /etc/sysctl.conf
  swapoff -a && swapon -a
  sysctl -p
  print_green "Swap已关闭并永久禁用"
}

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



Install_JDK_DEBIAN() {
  wget https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-jdk17.0.1-linux_x64.tar.gz
  mkdir -p /usr/java && tar -xzvf zulu17.30.15-ca-jdk17.0.1-linux_x64.tar.gz --strip-components 1 -C /usr/java
}

Install_Docker_Debian() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh --dry-run
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

