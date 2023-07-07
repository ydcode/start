#!/bin/bash

generate_random_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1
}

RANDOM_STRING=$(generate_random_string)

GLIDER_VERSION="0.16.3"
GLIDER_DIR="glider_${GLIDER_VERSION}_linux_amd64"
GLIDER_FILE="${GLIDER_DIR}.tar.gz"
GLIDER_URL="https://github.com/nadoo/glider/releases/download/v${GLIDER_VERSION}/${GLIDER_FILE}"

#检查glider是否存在
if ! [ -x "$(command -v ./glider)" ]; then
  #glider不存在，下载和解压
  wget ${GLIDER_URL}

  tar -xvf ${GLIDER_FILE}

  #进入程序所在目录
  cd ${GLIDER_DIR}
fi

#检查glider是否正在运行
if ! pgrep -x "glider" > /dev/null
then
    #glider没有运行，开始运行
    nohup ./glider -listen socks5://admin:${RANDOM_STRING}@:10888 >/dev/null 2>&1 &
fi

#获取本机公共IP
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)

#生成JSON输出
echo -n "{\"type\":\"socks5\",\"IP\":\"${PUBLIC_IP}\",\"port\":10888,\"username\":\"admin\",\"password\":\"${RANDOM_STRING}\"}" | jq
