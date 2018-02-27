#!/bin/bash
JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz"
MAVEN_URL="http://apache.mirror.colo-serv.net/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz"

JDK_FILE="jdk-8u162-linux-x64.tar.gz"
JDK_NAME="jdk1.8.0_162"

MAVEN_NAME="apache-maven-3.5.2"




Set_Timezone()
{
    Echo_Blue "Setting timezone..."
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

CentOS_InstallNTP()
{
    Echo_Blue "[+] Installing ntp..."
    yum install -y ntp
    ntpdate -u pool.ntp.org
    date
    start_time=$(date +%s)
}

Deb_InstallNTP()
{
    apt-get update -y
    Echo_Blue "[+] Installing ntp..."
    apt-get install -y ntpdate
    ntpdate -u pool.ntp.org
    date
    start_time=$(date +%s)
}

CentOS_RemoveAMP()
{
    Echo_Blue "[-] Yum remove packages..."
    rpm -qa|grep httpd
    rpm -e httpd httpd-tools --nodeps
    rpm -qa|grep mysql
    rpm -e mysql mysql-libs --nodeps
    rpm -qa|grep php
    rpm -e php-mysql php-cli php-gd php-common php --nodeps

    Remove_Error_Libcurl

    yum -y remove httpd*
    yum -y remove mysql-server mysql mysql-libs
    yum -y remove php*
    yum clean all
}

Deb_RemoveAMP()
{
    Echo_Blue "[-] apt-get remove packages..."
    apt-get update -y
    for removepackages in apache2 apache2-doc apache2-utils apache2.2-common apache2.2-bin apache2-mpm-prefork apache2-doc apache2-mpm-worker mysql-client mysql-server mysql-common mysql-server-core-5.5 mysql-client-5.5 php5 php5-common php5-cgi php5-cli php5-mysql php5-curl php5-gd;
    do apt-get purge -y $removepackages; done
    killall apache2
    dpkg -l |grep apache
    dpkg -P apache2 apache2-doc apache2-mpm-prefork apache2-utils apache2.2-common
    dpkg -l |grep mysql
    dpkg -P mysql-server mysql-common libmysqlclient15off libmysqlclient15-dev
    dpkg -l |grep php
    dpkg -P php5 php5-common php5-cli php5-cgi php5-mysql php5-curl php5-gd
    apt-get autoremove -y && apt-get clean
}

Disable_Selinux()
{
    if [ -s /etc/selinux/config ]; then
        sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
    fi
}



CentOS_Dependent()
{
    Echo_Blue "[+] Yum installing dependent packages..."
    yum update -y
    yum install -y git wget
}

Deb_Dependent()
{
    Echo_Blue "[+] Apt-get installing dependent packages..."
    apt-get update -y
    apt-get install -ygit wget 
}


Echo_Server_IP()
{
    IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
    IpSectionTwo=`echo "${IP}" |awk 'BEGIN{OFS=FS="."}{print $1,$2}'`
    Echo_Yellow "Server: ${ServerEnv}"
}

Check_Download()
{
    Echo_Blue "[+] Downloading files..."
    cd ${cur_dir}/src
    # Download_Files ${Download_Mirror}/lib/autoconf/${Autoconf_Ver}.tar.gz ${Autoconf_Ver}.tar.gz
}



if [ "$PM" = "yum" ]; then
    CentOS_Dependent
elif [ "$PM" = "apt" ]; then
    Deb_Dependent
fi

Echo_Server_IP


