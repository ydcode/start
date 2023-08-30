```
WSL 不要创建USER，初始化WSL时，直接取消，然后使用root 。方便通过ROOT 和正确的Root路径管理多Repo 证书
```

```
记得将该 setting.xml 拷贝到.m2目录(boot-cli 已自动复制)
```


# Docker 安装 (Docker Compose & JDK)
```
apt update && apt install -y git wget sudo \
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

# Glider SOCKS5
```
apt update && apt install -y git wget sudo
wget https://raw.githubusercontent.com/ydcode/start/master/tools/glider/install_glider.sh
sudo chmod +x install_glider.sh && sudo ./install_glider.sh
```