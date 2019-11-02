记得将该 setting.xml 拷贝到.m2目录

# 第一步: 添加环境变量
```
vi ~/.bashrc
参考有道笔记
```


# 第二步: Docker 安装 (Java & Maven)
```
centos + docker bug: 重启无法连接ssh,未排查到具体原因
apt install -y git wget \
&& cd /root && git clone https://github.com/ydcode/start.git \
&& cd /root/start/tools/docker/ && chmod +x ./install.sh && ./install.sh && apt autoremove -y
```


# Mulit Repo
```
cd /root/ && git clone https://github.com/ydcode/start.git && cd start/tools/github && chmod +x muliti-repo-init-root.sh && ./muliti-repo-init-root.sh && cd /root
```

# Maven 重要  Exception: Nexus 401
```
cp settings.xml /root/.m2/
```


# ShadowSocks
```
yum install -y git && cd /root/ && git clone https://github.com/ydcode/start.git && cd start/tools/shadowsocks && chmod +x CentOS_ShadowSocks_Install.sh && ./CentOS_ShadowSocks_Install.sh


apt install -y git && cd /root/ && git clone https://github.com/ydcode/start-common.git && cd start/tools/shadowsocks && chmod +x Debian_ShadowSocks_Install.sh && ./Debian_ShadowSocks_Install.sh
```
