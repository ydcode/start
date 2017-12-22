#解除限制
xhost +
apt remove -y vim-common
apt update
apt install -y gdebi git openjdk-8-jdk vim

#download sougou deb
#gdebi sougou.deb
#language supoort --- set method system: fcitx  ---log out  ---  fcitx Add Sogou ---ctrl + space


# proxy
add-apt-repository -y ppa:hzwhuang/ss-qt5
apt update
apt install -y shadowsocks-qt5

# auto start  /usr/bin/ss-qt5 
touch /home/allen/.config/autostart/ss-qt5.desktop

#将下方内容写入到该文件
[Desktop Entry]
Type=Application
Exec=/usr/bin/ss-qt5
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=ss
Name=ss
Comment[en_US]=ss
Comment=ss

apt install -y proxychains
# edit   vi /etc/proxychains.conf   127.0.0.1 7070

#proxychains + app

#proxychains firefox to down load chrome deb --- gdebi google_chrome.deb
#first open chrome by click icon, after setting done. proxychains google-chrome to login   auto load bookmark and extension



# docker
#download docker deb
sudo gdebi docker.deb
# shutter guake
