记得将该 setting.xml 拷贝到.m2目录

# 编辑 ~/.bashrc
```
export DOCKER_ALIYUN_REGISTRY=registry.us-east-1.aliyuncs.com
export DOCKER_ALIYUN_REPOSITORY=****
export DOCKER_ALIYUN_USERNAME=****
export DOCKER_ALIYUN_PASSWORD=****
```

# Docker 安装 (Java & Maven)
```
centos + docker bug: 重启无法连接ssh,未排查到具体原因
apt install -y git wget \
&& cd /root && git clone https://github.com/ydcode/start.git \
&& cd /root/start/tools/docker/ && chmod +x ./install.sh && ./install.sh && apt autoremove
```



# Nexus Deploy
```
cd /root/boot/boot-project/docker-images/nexus-cli/ \
&& git pull origin dev \
&&  mvn -DDOCKER_REGISTRY=${DOCKER_IO_REGISTRY} -DDOCKER_REPOSITORY=ydcode -DDOCKER_USERNAME=${DOCKER_IO_USERNAME} -DDOCKER_PASSWORD=${DOCKER_IO_PASSWORD}  -U -T 1C clean compile install deploy
```

# Nexus Run
```
docker rm -f nexus-cli \
&& docker pull docker.io/ydcode/nexus-cli:latest \
&& docker run -d --restart=always --name nexus-cli docker.io/ydcode/nexus-cli:latest && docker logs -f nexus-cli

```

```
vi ~/.bashrc  添加环境变量
apt install -y git wget sudo \
&& cd /root && git clone https://github.com/ydcode/start.git \
&& cd /root/start/tools/docker/ && chmod +x ./install.sh && ./install.sh
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
