#!/bin/bash

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
    apt-get autoremove -y
    apt-get -fy install
    export DEBIAN_FRONTEND=noninteractive
    apt-get --no-install-recommends install -y build-essential gcc g++ make
    for packages in debian-keyring debian-archive-keyring build-essential gcc g++ make cmake autoconf automake re2c git wget cron bzip2 libzip-dev libc6-dev bison file rcconf flex vim bison m4 gawk less cpp binutils diffutils unzip tar bzip2 libbz2-dev libncurses5 libncurses5-dev libtool libevent-dev openssl libssl-dev zlibc libsasl2-dev libltdl3-dev libltdl-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-0 libglib2.0-dev libpng3 libjpeg-dev libpng-dev libpng12-0 libpng12-dev libkrb5-dev curl libcurl3 libcurl3-gnutls libcurl4-gnutls-dev libcurl4-openssl-dev libpq-dev libpq5 gettext libjpeg-dev libpng12-dev libxml2-dev libcap-dev ca-certificates libc-client2007e-dev psmisc patch git libc-ares-dev libicu-dev e2fsprogs libxslt libxslt1-dev libc-client-dev xz-utils libexpat1-dev;
    do apt-get --no-install-recommends install -y $packages --force-yes; done
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
    Download_Files ${Download_Mirror}/lib/autoconf/${Autoconf_Ver}.tar.gz ${Autoconf_Ver}.tar.gz
}


