sudo yum remove -y docker docker-common  docker-selinux docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
sudo yum install -y  docker-ce
sudo systemctl start docker


if grep -q "/usr/local/bin" "/etc/profile"; then #条目已存在
        Echo_Green "/usr/local/bin Exist."
else
    echo 'export PATH=$PATH:/usr/local/bin' >>  /etc/profile
fi
source /etc/profile
source /etc/profile

sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version


