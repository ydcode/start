apt install -y gdebi shutter guake git
apt upgrade -y
add-apt-repository ppa:hzwhuang/ss-qt5
apt-get update
apt-get install shadowsocks-qt5

if grep -q "/usr/bin/guake" "/etc/profile"; then #条目已存在
  Echo_Green "/etc/profile  guake auto start Exist."
else
  echo "/usr/bin/guake &" >> /etc/profile
  source /etc/profile
fi
    
# sougou https://jingyan.baidu.com/article/a3aad71aa1abe7b1fa009641.html
# 云音乐
# chrome
