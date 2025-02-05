#!/bin/bash

install_docker__debian() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh

  sudo systemctl start docker
  sudo systemctl enable docker
}


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


## 主要函数调用
#set_ulimit_max_permanently
#check_and_disable_swap
#
## Oceanbase
#sed -i '/^fs.aio-max-nr\s*=.*/d' /etc/sysctl.conf
#echo "fs.aio-max-nr = 1048576" >> /etc/sysctl.conf
#sysctl -p

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

