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


cd /root/.aleo/storage

tar -zvcf ledger.tar.gz ledger-2
mv ledger.tar.gz /home/temp/
cd /home/temp

ip=$(curl -s http://checkip.amazonaws.com)
echo ""
echo ""
echo ""
echo ""
echo "--->"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo "cd /home/gce/shared && wget http://$ip:9090/ledger.tar.gz"
echo ""
echo ""
echo ""

ls -al
http-server -p 9090
