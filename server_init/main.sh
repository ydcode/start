#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/java/jdk1.8.0_101/bin:/usr/java/jdk1.8.0_101/jre/bin:/usr/java/jdk1.8.0_101/include:/usr/maven/apache-maven-3.5.0/bin:/root/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi
. include/A_Begin.sh
. include/B_Soft_Docker.sh
#. include/B_Soft_JDK_MVN.sh

#安装Jemollo
