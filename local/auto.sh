#!/bin/bash


Install_JDK()
{
    files=`ls /usr/java/`
    if [ -z "$files" ]; then
        rm -rf /usr/java
    fi
    cd ${CurrentDir}
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
            Echo_Green "JDK Item Exist."
        else
            echo "export JAVA_HOME=/usr/java/${JDK_NAME}" >> /etc/profile
            echo "export JRE_HOME=/usr/java/${JDK_NAME}/jre" >> /etc/profile
            echo "export MAVEN_HOME=/usr/maven" >> /etc/profile
            echo 'export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$JRE_HOME/include:$MAVEN_HOME/bin:/usr/local/bin' >>  /etc/profile
            source /etc/profile

            Echo_Yellow "Open new Terminal and once again './main.sh' and "
            Echo_Green "Ctrl + C to exit"
            get_char
        fi

        cd ${CurrentDir}
	else
		Echo_Green "JDK already installed."
    fi
}

Install_MVN(){
        if [ ! -d "/usr/maven/" ]; then
            cd ${CurrentDir}
            wget ${MAVEN_URL}
	    mkdir /usr/maven && tar xzvf apache-maven*.tar.gz --strip-components 1  -C /usr/maven/
        fi
}


