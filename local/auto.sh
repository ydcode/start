#!/bin/bash

apt remove -y vim-common
apt update
apt install -y gdebi git vim

add-apt-repository -y ppa:hzwhuang/ss-qt5
apt update
apt install -y shadowsocks-qt5

apt install -y proxychains

#sumlime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text



JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"
JDK_FILE="jdk-8u131-linux-x64.tar.gz"
JDK_NAME="jdk1.8.0_131"


Install_JDK()
{
	files=`ls /usr/java/`
	if [ -z "$files" ]; then
		rm -rf /usr/java
	fi
		cd /root
		pwd
	if [ ! -d "/usr/java/" ]; then
		source /etc/profile
		if [ ! -e "${JDK_FILE}" ]; then
		    wget --continue --no-check-certificate --header "Cookie: oraclelicense=a" ${JDK_URL}
	#            'http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz'
		fi
		mkdir /usr/java && tar zxvf jdk*.tar.gz -C /usr/java/
		ln -s /usr/java/${JDK_NAME}/bin/java /usr/local/bin/java #必要

		if grep -q "/usr/java/jdk" "/etc/profile"; then #条目已存在
		    echo "JDK Item Exist."
		else
		    echo "export JAVA_HOME=/usr/java/${JDK_NAME}" >> /etc/profile
		    echo "export JRE_HOME=/usr/java/${JDK_NAME}/jre" >> /etc/profile
		    echo "export MAVEN_HOME=/usr/maven" >> /etc/profile
		    echo 'export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$JRE_HOME/include:$MAVEN_HOME/bin:/usr/local/bin' >>  /etc/profile
		    source /etc/profile

		    echo "Open new Terminal and once again './main.sh' and "
		fi

		cd /root
	else
		echo "JDK already installed."
	fi
}

Install_JDK



MAVEN_URL="http://apache.mirror.colo-serv.net/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz"
MAVEN_NAME="apache-maven-3.5.2"


Install_MVN(){
        if [ ! -d "/usr/maven/" ]; then
            cd ${CurrentDir}
            wget ${MAVEN_URL}
	    mkdir /usr/maven && tar xzvf apache-maven*.tar.gz --strip-components 1  -C /usr/maven/
        fi
}

Install_MVN



