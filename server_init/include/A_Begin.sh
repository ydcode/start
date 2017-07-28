#!/bin/bash

#等待函数
get_char()
{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}


yum update -y
yum install -y git wget

CurrentDir=`pwd`
IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
IpSectionTwo=`echo "${IP}" |awk 'BEGIN{OFS=FS="."}{print $1,$2}'`

Echo_Yellow "Server: ${ServerEnv}"


JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"
MAVEN_URL="http://www-eu.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz"
JDK_FILE="jdk-8u131-linux-x64.tar.gz"
JDK_NAME="jdk1.8.0_131"
MAVEN_NAME="apache-maven-3.5.0"
Nginx_Ver="1.12.0"



