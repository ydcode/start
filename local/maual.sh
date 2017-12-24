### 关闭 access controll并清屏  normal user
echo "xhost + && clear && printf '\e[3J'" >> $HOME/.bashrc

##normal user + sudo

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

# guake
# auto start  /usr/bin/guake
touch /home/allen/.config/autostart/guake.desktop

#将下方内容写入到该文件
[Desktop Entry]
Type=Application
Exec=/usr/bin/guake
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=guake
Name=guake
Comment[en_US]=guake
Comment=guake



# edit   vi /etc/proxychains.conf   127.0.0.1 7070

#proxychains + app

#proxychains firefox to down load chrome deb --- gdebi google_chrome.deb
#first open chrome by click icon, after setting done. proxychains google-chrome to login   auto load bookmark and extension


# docker
#download docker deb
sudo gdebi docker.deb
# shutter guake

#idea without jdk   ---- sudo idea by normal user
使用前请将“0.0.0.0 account.jetbrains.com”添加到hosts文件中
安装 plugin: lombok gitignore jrebel + 激活码即可
Shift+Ctrl+Alt+/ --- 选择Registry --- compiler.automake.allow.when.app.running enable
setting --- comipile --- Build Project Automatically
restart idea

init repo
apt upgrade -y

### 设置分辨率
http://www.omgubuntu.co.uk/2017/09/enable-fractional-scaling-gnome-linux


## 安装 SecureCRT    switch to root  and run (not sudo)

如果有libpng12错误，则下方可以解决
wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && dpkg -i /tmp/libpng12.deb \
  && rm /tmp/libpng12.deb
  
rm -f ~/.vandyke
wget http://download.boll.me/securecrt_linux_crack.pl
sudo perl securecrt_linux_crack.pl /usr/bin/SecureCRT
Manuel Enter Key

#gec ssh
ssh-keygen -t rsa -f /root/.ssh/id_rsa.gce -C "gce"
copy pub to gce ssh key


