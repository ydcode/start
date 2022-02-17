#!/bin/bash

Install_NodeJS()
{
  curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
  sudo apt-get install -y nodejs
  npm install --global http-server
}


if [ ! -e "/usr/bin/node" ]; then
  Install_NodeJS
fi

mkdir -p /home/temp && cd /home/temp


cd /var/lib/docker/volumes/ironfish_data/_data

tar -zvcf ironfish_data.tar.gz databases
mv ironfish_data.tar.gz /home/temp/
cd /home/temp

date_suffix=$(date +%Y-%m-%d-%H-%M)

ip=$(curl -s http://checkip.amazonaws.com)
echo ""
echo ""
echo ""
echo ""
echo "Nexus Server --->"
echo "cd /var/lib/docker/volumes/wwwroot_data/_data/download.thrivemobi.net && ([ ! -f ironfish_data.tar.gz ] || mv ironfish_data.tar.gz ironfish_data_BAK_$date_suffix.tar.gz) && wget http://$ip:9090/ironfish_data.tar.gz"
echo ""
echo ""
echo ""

ls -al
http-server -p 9090
