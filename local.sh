apt install -y gdebi shutter guake git
apt upgrade -y
add-apt-repository ppa:hzwhuang/ss-qt5
apt-get update
apt-get install shadowsocks-qt5
apt install -y proxychains

sudo apt-get remove docker docker-engine docker.io

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
 
 
# ubuntu auto start guake ss-qt5    
# sougou https://jingyan.baidu.com/article/a3aad71aa1abe7b1fa009641.html
# 云音乐
# chrome
