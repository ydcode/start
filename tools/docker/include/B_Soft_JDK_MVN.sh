#!/bin/bash


Install_JDK()
{
    files=`ls /usr/java/`
    if [ -z "$files" ]; then
        rm -rf /usr/java
    fi
    cd ${CurrentDir}
    pwd
    
	rm -rf /usr/java
	rm -rf /usr/local/bin/java
	
    if [ ! -d "/usr/java/" ]; then
    	source ~/.bashrc
        if [ ! -e "${JDK_FILE}" ]; then
            wget --continue --no-check-certificate --header "Cookie: oraclelicense=a" ${JDK_URL}
        fi
	

    	mkdir /usr/java && tar xzvf openjdk*.tar.gz --strip-components 1  -C /usr/java/
	ln -s /usr/java/bin/java /usr/local/bin/java #必要

        if grep -q "/usr/java/jdk" "~/.bashrc"; then #条目已存在
            Echo_Green "JDK Item Exist."
        else
            echo "export JAVA_HOME=/usr/java/" >> ~/.bashrc
            echo "export JRE_HOME=/usr/java/jre" >> ~/.bashrc
            echo "export MAVEN_HOME=/usr/maven" >> ~/.bashrc
            echo 'export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$JRE_HOME/include:$MAVEN_HOME/bin:/usr/local/bin' >>  ~/.bashrc
            source ~/.bashrc

	    java -version
            Echo_Yellow "manual 'source ~/.bashrc' "
            Echo_Green "Ctrl + C to exit"
        fi

        cd ${CurrentDir}
	else
		Echo_Green "JDK already installed."
    fi
}

Install_MVN(){
	rm -rf /usr/maven
        if [ ! -d "/usr/maven/" ]; then
            cd ${CurrentDir}
            wget ${MAVEN_URL}
	    mkdir /usr/maven && tar xzvf apache-maven*.tar.gz --strip-components 1  -C /usr/maven/
        fi
}


JDK_MVN_Choice()
{
	JdkMvnChoice="n"
	Echo_Yellow "Add JDK && MVN (!!! Prod env NO need java and mvn)?"
	read -p "Default No,Enter your choice [y/N]: " JdkMvnChoice

	case "${JdkMvnChoice}" in
	[yY][eE][sS]|[yY])
		echo "You will add JDK && MVN"
		JdkMvnChoice="y"
		;;
	[nN][oO]|[nN])
		echo "No JDK && MVN"
		JdkMvnChoice="n"
		;;
	*)
	esac

	if [ "${JdkMvnChoice}" = "y" ]; then
		Install_MVN
		Install_JDK
	else
		Echo_Yellow "Choose No JDK && MVN"
	fi
}

JDK_MVN_Choice



