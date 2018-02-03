if [ ! -e "/usr/bin/docker" ]; then

        sudo yum remove -y docker docker-common  docker-selinux docker-engine
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
        sudo yum install -y  docker-ce
        sudo systemctl start docker
        sudo systemctl enable docker #开机启动

        if grep -q "/usr/local/bin" "~/.bashrc"; then #条目已存在
                Echo_Green "/usr/local/bin Exist."
        else
            echo 'export PATH=$PATH:/usr/local/bin' >>  ~/.bashrc
        fi
        source ~/.bashrc
        sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        docker-compose --version
        
        sudo systemctl start docker
fi
    
    


