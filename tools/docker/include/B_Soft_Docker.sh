Install_Docker_CentOS()
{
        sudo yum remove -y docker docker-common  docker-selinux docker-engine
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2

        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
        sudo yum install -y  docker-ce
}

Install_Docker_Fedora()
{
       sudo dnf remove -y docker docker-common docker-selinux docker-engine-selinux docker-engine
       sudo dnf -y install dnf-plugins-core
       sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
       sudo dnf install -y docker-ce
}


Install_Docker_Ubuntu()
{
        sudo apt-get update -y
        sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        apt-get update -y
        apt-get install -y docker-ce
}


Install_Docker_Debian()
{
        sudo apt-get update -y
        apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        apt-get update -y
        apt-get install -y docker-ce
}


Install_Docker_Compose()
{
        sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        docker-compose --version
}
    

if [ ! -e "/usr/bin/docker" ]; then

        Echo_Green $DISTRO
        
        if [ "$DISTRO" = "CentOS" ]; then
                Install_Docker_CentOS
        elif [ "$DISTRO" = "Fedora" ]; then
                Install_Docker_Fedora
        elif [ "$DISTRO" = "Debian" ]; then
                Install_Docker_Debian
        elif [ "$DISTRO" = "Ubuntu" ]; then
                Install_Docker_Ubuntu
        elif [ "$DISTRO" = "Amazon" ]; then
                Install_Docker_CentOS
        fi
fi


Install_Docker_Compose

sudo systemctl start docker
sudo systemctl enable docker #开机启动

if grep -q "/usr/local/bin" "~/.bashrc"; then #条目已存在
        Echo_Green "/usr/local/bin Exist."
else
        echo 'export PATH=$PATH:/usr/local/bin' >>  ~/.bashrc
fi
source ~/.bashrc
source ~/.bashrc
source ~/.bashrc

sudo systemctl start docker

docker run hello-world

# docker login

if [ "${DOCKER_USERNAME}" = "" ]
then
    echo "DOCKER_USERNAME is not set!"
else
    echo "------------------------------------------------------------------"
    echo "docker login -u ${DOCKER_USERNAME} -p DOCKER_PASSWORD ${DOCKER_REGISTRY}"
    docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY}
fi


if [ "${DOCKER_ALIYUN_USERNAME}" = "" ]
then
    echo "DOCKER_ALIYUN_USERNAME is not set!"
else
    echo "------------------------------------------------------------------"
    echo "docker login -u ${DOCKER_ALIYUN_USERNAME} -p DOCKER_PASSWORD ${DOCKER_ALIYUN_REGISTRY}"
    docker login -u ${DOCKER_ALIYUN_USERNAME} -p ${DOCKER_ALIYUN_PASSWORD} ${DOCKER_ALIYUN_REGISTRY}
fi




