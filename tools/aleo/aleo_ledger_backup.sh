#!/bin/bash

mkdir -p /home/temp && cd /home/temp

curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install --global http-server

cd /root/.aleo/storage

tar -zvcf ledger.tar.gz ledger-2
mv ledger.tar.gz /home/temp/
cd /home/temp
http-server -p 9090