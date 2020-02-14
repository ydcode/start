#!/bin/bash


Install_JDK_DEBIAN()
{
	apt install -y openjdk-11-jdk
}


Install_MVN_DEBIAN()
{
	MAVEN_URL="http://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
	MAVEN_NAME="apache-maven-3.6.3"
	rm -rf /usr/maven
        if [ ! -d "/usr/maven/" ]; then
		cd ${CurrentDir}
		wget ${MAVEN_URL}
		mkdir /usr/maven && tar xzvf apache-maven*.tar.gz --strip-components 1  -C /usr/maven/
	    
		if grep -q "MAVEN_HOME" "~/.bashrc"; then #条目已存在
		    Echo_Green "MAVEN Item Exist."
		else
		    echo "export MAVEN_HOME=/usr/maven" >> ~/.bashrc
		    echo 'export PATH=$PATH:$MAVEN_HOME/bin:/usr/local/bin' >>  ~/.bashrc
		    source ~/.bashrc
		fi
        fi
}


JDK_MVN_Choice()
{
	JdkMvnChoice="n"
	Echo_Yellow "Add JDK && MVN (!!! Prod env NO need java and mvn)?"
	read -p "Default No,Enter your choice [y (Nexus Dev) / N (Prod) ]: " JdkMvnChoice

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
		Install_MVN_DEBIAN
		Install_JDK_DEBIAN
	else
		Echo_Yellow "Choose No JDK && MVN"
	fi
}

JDK_MVN_Choice



