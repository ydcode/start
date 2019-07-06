#!/bin/bash


Install_JDK_DEBIAN()
{
	apt install -y openjdk-11-jdk
}


Install_MVN_DEBIAN()
{
	apt install -y maven
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
		Install_MVN_DEBIAN
		Install_JDK_DEBIAN
	else
		Echo_Yellow "Choose No JDK && MVN"
	fi
}

JDK_MVN_Choice



