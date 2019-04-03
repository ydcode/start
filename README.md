记得将该 setting.xml 拷贝到.m2目录



# Docker 安装 (Java &&& Maven)
```
centos + docker bug: 重启无法连接ssh,未排查到具体原因
yum install -y git wget && cd /root && git clone https://github.com/ydcode/start.git && cd start 
```


```
vi ~/.bashrc  添加环境变量
apt install -y git wget sudo \
&& cd /root && git clone https://github.com/ydcode/start.git \
&& cd /root/start/docker/server_init/ && ./install.sh
```



# Mulit Repo
```
cd /root/ && git clone https://github.com/ydcode/start.git && cd start/tools/github && chmod +x muliti-repo-init-root.sh && ./muliti-repo-init-root.sh && cd /root

```


# ShadowSocks
```
yum install -y git && cd /root/ && git clone https://github.com/ydcode/start.git && cd start/tools/shadowsocks && chmod +x CentOS_ShadowSocks_Install.sh && ./CentOS_ShadowSocks_Install.sh


apt install -y git && cd /root/ && git clone https://github.com/ydcode/start-common.git && cd start/tools/shadowsocks && chmod +x Debian_ShadowSocks_Install.sh && ./Debian_ShadowSocks_Install.sh
```



service network restart

```
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
***********************************************
EOF


cat << EOF > /etc/sysconfig/network-scripts/route-eth0
***********************************************
EOF

cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth1
***********************************************
EOF
```
