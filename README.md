记得将该 setting.xml 拷贝到.m2目录

# 编辑 ~/.bashrc  参见有道笔记
```
export APPLICATION_VERSION=latest

export DOCKER_ALIYUN_REGISTRY=registry.us-east-1.aliyuncs.com
export DOCKER_ALIYUN_REPOSITORY=*
export DOCKER_ALIYUN_USERNAME=*
export DOCKER_ALIYUN_PASSWORD=*

export DOCKER_REGISTRY=*
export DOCKER_REPOSITORY=*
export DOCKER_USERNAME=*
export DOCKER_PASSWORD=*

export NEXUS_HOST=*
export NEXUS_USERNAME=*
export NEXUS_PASSWORD=*

```

# Docker 安装 (Java & Maven)
```
centos + docker bug: 重启无法连接ssh,未排查到具体原因
apt install -y git wget \
&& cd /root && git clone https://github.com/ydcode/start.git \
&& cd /root/start/tools/docker/ && chmod +x ./install.sh && ./install.sh && apt autoremove -y
```

```排查
Nexus Docker开放端口
Nexus Push 开放端口
Registry 端口
unsecure http 开放端口
docker compose yml 端口小于1000的，要用双引号包含，以免Yaml解析错误
```

# Nexus Deploy Aliyun
```
cd /root/boot/boot-project/cli/ \
&& git pull origin dev &&  mvn -U -T 1C clean compile install deploy

cd /root/boot/boot-project/docker-images/docker-nginx/ \
&& git pull origin dev &&  mvn -U -T 1C clean compile install deploy -P aliyun
```

# Nexus Cli Run
```
docker pull ${DOCKER_ALIYUN_REGISTRY}/ydcode/nexus-cli:latest \
&& docker run -it --name nexus-cli \
--env DOCKER_ALIYUN_REGISTRY=${DOCKER_ALIYUN_REGISTRY} \
--env APPLICATION_VERSION=${APPLICATION_VERSION} \
-v /root:/root \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
-v /usr/local/bin/docker-compose:/usr/local/bin/docker-compose \
-v wwwroot_data:/home/wwwroot \
-v ssl_data:/etc/letsencrypt \
-v nginx_conf_data:/etc/nginx/conf.d \
${DOCKER_ALIYUN_REGISTRY}/ydcode/nexus-cli:latest
```

```
创建Docker Repo: ydcode
maven-release 记得要开启 Allow Redeploy

开启http端口: 6666
Realms 开启 Docker Bearer
Realms 开启 NPM Bearer

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
