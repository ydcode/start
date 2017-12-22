!!! 为尽量避免权限问题，要直接切换到Root
#解除限制
xhost +


#download sougou deb
#gdebi sougou.deb
#language supoort --- set method system: fcitx  ---log out  ---  fcitx Add Sogou ---ctrl + space


# proxy
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

# edit   vi /etc/proxychains.conf   127.0.0.1 7070

#proxychains + app

#proxychains firefox to down load chrome deb --- gdebi google_chrome.deb
#first open chrome by click icon, after setting done. proxychains google-chrome to login   auto load bookmark and extension


# docker
#download docker deb
sudo gdebi docker.deb
# shutter guake
idea without jdk   ---- sudo idea by normal user
使用前请将“0.0.0.0 account.jetbrains.com”添加到hosts文件中


init repo
apt upgrade -y
