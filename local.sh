apt install -y gdebi shutter guake git
apt upgrade -y
add-apt-repository ppa:hzwhuang/ss-qt5
apt-get update
apt-get install shadowsocks-qt5

/usr/bin/guake &
/usr/bin/ss-qt5 &

if grep -q "nohup /usr/bin/guake &" "$HOME/.bashrc"; then #条目已存在
  Echo_Green "$HOME/.bashrc  nohup /usr/bin/guake --- auto start Exist."
else
  echo "nohup /usr/bin/guake &" >> $HOME/.bashrc
  source $HOME/.bashrc
fi
    
    
if grep -q "nohup /usr/bin/ss-qt5 &" "$HOME/.bashrc"; then #条目已存在
  Echo_Green "nohup /usr/bin/ss-qt5 &  --- auto start Exist."
else
  echo "nohup /usr/bin/ss-qt5 &" >> $HOME/.bashrc
  source $HOME/.bashrc
fi
    

    
# sougou https://jingyan.baidu.com/article/a3aad71aa1abe7b1fa009641.html
# 云音乐
# chrome
