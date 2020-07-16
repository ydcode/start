```
WSL 不要创建USER，初始化WSL时，直接取消，然后使用root 。方便通过ROOT 和正确的Root路径管理多Repo 证书
```

```
docker run -d centos /bin/sh -c "while true; do echo hello world; sleep 1; done"
```

```
记得将该 setting.xml 拷贝到.m2目录(boot-cli 已自动复制)
```

# 第0步: Nexus 80GB SSD DISK
```
```

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


----------------------------------------------------------------------------------------------------
# Init Repo
```
cd /root/start/tools/github && chmod +x muliti-repo-init-root.sh && ./muliti-repo-init-root.sh && cd /root
```
OR
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




# FRP Server
```
apt install -y wget git && cd /root/ && git clone https://github.com/ydcode/start-common.git && cd start/tools/frp && chmod +x frp-server.sh && ./frp-server.sh
```

# FRP Client
```
apt install -y wget git && cd /root/ && git clone https://github.com/ydcode/start-common.git && cd start/tools/frp && chmod +x frp-client.sh && ./frp-client.sh

```
