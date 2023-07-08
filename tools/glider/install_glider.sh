#!/bin/bash
set -x

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
for cmd in jq wget curl pgrep; do
    if ! [ -x "$(command -v $cmd)" ]; then
        sudo $PKG_MANAGER update -y
        sudo $PKG_MANAGER install $cmd -y
    fi
done

generate_random_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1
}

GLIDER_VERSION="0.16.3"
GLIDER_DIR="glider_${GLIDER_VERSION}_linux_amd64"
GLIDER_FILE="${GLIDER_DIR}.tar.gz"
GLIDER_URL="https://github.com/nadoo/glider/releases/download/v${GLIDER_VERSION}/${GLIDER_FILE}"
CONFIG_FILE="./glider_config.json"

# 如果没有找到配置文件，结束所有的 glider 进程
if ! [ -f "${CONFIG_FILE}" ]; then
    pkill -f glider
fi

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

#获取本机公共IP
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com) || { echo "curl failed. Exiting."; exit 1; }

if [ -f "$CONFIG_FILE" ]; then
    # Glider正在运行，读取配置文件并生成JSON
    cat ${CONFIG_FILE} | jq || { echo "jq failed. Exiting."; exit 1; }

    if ! pgrep -x "glider" > /dev/null
    then
        echo "Glider is not running. Starting..."
        PASSWORD=$(jq -r '.password' ${CONFIG_FILE})
        nohup ./glider -listen socks5://admin:${PASSWORD}@:10888 >/dev/null 2>&1 &
    fi
else
    # Glider没有运行，开始运行
    RANDOM_STRING=$(generate_random_string)
    nohup ./glider -listen socks5://admin:${RANDOM_STRING}@:10888 >/dev/null 2>&1 &

    #保存配置到文件
    echo -n "{\"type\":\"socks5\",\"IP\":\"${PUBLIC_IP}\",\"port\":10888,\"username\":\"admin\",\"password\":\"${RANDOM_STRING}\"}" > ${CONFIG_FILE}

    # 输出分割符
    echo "========================================================================"

    #生成JSON输出
    cat ${CONFIG_FILE} | jq || { echo "jq failed. Exiting."; exit 1; }

    # 输出分割符
    echo "========================================================================"
fi

# 检查并输出 Glider 是否在运行
if pgrep -x "glider" > /dev/null
then
    echo "Glider is running."
else
    echo "Glider is not running."
fi

# 删除旧的安装包
rm -f ${GLIDER_FILE}