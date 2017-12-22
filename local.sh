apt remove vim-common
apt install -y gdebi git openjdk-8-jdk vim
# install sougou  fcitx 配置 重启
# sougou https://jingyan.baidu.com/article/a3aad71aa1abe7b1fa009641.html


# proxy
add-apt-repository ppa:hzwhuang/ss-qt5
apt update
apt install shadowsocks-qt5
# auto start  /usr/bin/ss-qt5 
apt install -y proxychains
# edit   vi /etc/proxychains.conf   127.0.0.1 7070
#proxychains + app
# chrome

# shutter guake

# docker
sudo apt remove docker docker-engine docker.io

sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) \
 stable"
sudo apt-get update 
sudo apt-get install -y docker-ce
