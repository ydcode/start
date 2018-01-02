apt install -y proxychains wget curl git
# 修改 /etc/proxchains.conf

#JAVA_HOME 添加 _UBUNTU后缀是为了和其他变量（未知，导致mvn识别jdk未知错误）混淆
#安装后要重启terminal

JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-linux-x64.tar.gz"
JDK_FILE="jdk-8u152-linux-x64.tar.gz"
JDK_NAME="jdk1.8.0_152"


Install_JDK()
{
	files=`ls /usr/java/`
	if [ -z "$files" ]; then
		rm -rf /usr/java
	fi
		cd ~
		pwd
	if [ ! -d "/usr/java/" ]; then
		source ~/.bashrc
		if [ ! -e "${JDK_FILE}" ]; then
		    wget --continue --no-check-certificate --header "Cookie: oraclelicense=a" ${JDK_URL}
		fi
		mkdir /usr/java && tar zxvf jdk*.tar.gz -C /usr/java/
		ln -s /usr/java/${JDK_NAME}/bin/java /usr/local/bin/java #必要

		if grep -q "/usr/java/jdk" "~/.bashrc"; then #条目已存在
		    echo "JDK Item Exist."
		else
	
		

			echo 'export JAVA_HOME_UBUNTU=/usr/java/${JDK_NAME}' >> ~/.bashrc
			echo 'export JRE_HOME_UBUNTU=/usr/java/${JDK_NAME}/jre' >> ~/.bashrc
			echo 'export PATH=$PATH:$JAVA_HOME_UBUNTU/bin:$JRE_HOME_UBUNTU/bin:$JRE_HOME_UBUNTU/include:/usr/maven/bin:/usr/local/bin' >>  ~/.bashrc
			source ~/.bashrc
			
			echo 'export PATH=$HOME/bin:$HOME/.local/bin:$PATH' >> ~/.bashrc
			echo 'export PATH=$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin' >> ~/.bashrc
			echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc
			source ~/.bashrc

		    echo "Open new Terminal and once again './main.sh' and "
		fi

		cd ~
	else
		echo "JDK already installed."
	fi
}

Install_JDK



MAVEN_URL="http://apache.mirror.colo-serv.net/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz"
MAVEN_NAME="apache-maven-3.5.2"
MAVEN_FILE="apache-maven-3.5.2-bin.tar.gz"


Install_MVN(){
        if [ ! -d "/usr/maven/" ]; then
		cd ${CurrentDir}
		if [ ! -e "${MAVEN_FILE}" ]; then
			wget ${MAVEN_URL}
		fi
		mkdir /usr/maven && tar xzvf apache-maven*.tar.gz --strip-components 1  -C /usr/maven/
        fi
}

Install_MVN



sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version




