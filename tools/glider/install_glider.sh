#!/bin/bash

# 选择合适的包管理器
if [ -x "$(command -v apt-get)" ]; then
    PKG_MANAGER="apt-get"
elif [ -x "$(command -v yum)" ]; then
    PKG_MANAGER="yum"
else
    echo "Neither apt-get nor yum found. Exiting."
    exit 1
fi

# 安装必要的命令
for cmd in jq wget curl; do
    if ! [ -x "$(command -v $cmd)" ]; then
        sudo $PKG_MANAGER update -y
        sudo $PKG_MANAGER install $cmd -y
    fi
done

generate_random_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1
}

RANDOM_STRING=$(generate_random_string)

GLIDER_VERSION="0.16.3"
GLIDER_DIR="glider_${GLIDER_VERSION}_linux_amd64"
GLIDER_FILE="${GLIDER_DIR}.tar.gz"
GLIDER_URL="https://github.com/nadoo/glider/releases/download/v${GLIDER_VERSION}/${GLIDER_FILE}"

# 检查并删除已存在的旧安装包
if [ -f "${GLIDER_FILE}" ]; then
    rm -f ${GLIDER_FILE}
fi

#检查glider是否存在
if ! [ -x "$(command -v ./glider)" ]; then
  #glider不存在，下载和解压
  wget --header="Cache-Control: no-cache" ${GLIDER_URL} || { echo "wget failed. Exiting."; exit 1; }

  tar -xvf ${GLIDER_FILE} || { echo "tar failed. Exiting."; exit 1; }

  #进入程序所在目录
  cd ${GLIDER_DIR} || { echo "cd failed. Exiting."; exit 1; }
fi

#检查glider是否正在运行
if ! pgrep -x "glider" > /dev/null
then
    #glider没有运行，开始运行
    nohup ./glider -listen socks5://admin:${RANDOM_STRING}@:10888 >/dev/null 2>&1 &
fi

#获取本机公共IP
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com) || { echo "curl failed. Exiting."; exit 1; }

# 输出分割符
echo "=========================================="

#生成JSON输出
echo -n "{\"type\":\"socks5\",\"IP\":\"${PUBLIC_IP}\",\"port\":10888,\"username\":\"admin\",\"password\":\"${RANDOM_STRING}\"}" | jq || { echo "jq failed. Exiting."; exit 1; }

# 输出分割符
echo "=========================================="

# 删除旧的安装包
rm -f ${GLIDER_FILE}
