#!/bin/bash

cd /root

wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.12.6.linux-amd64.tar.gz

if grep -q "/usr/local/go/bin" "~/.bashrc"; then #条目已存在
        echo "/usr/local/bin Exist."
else
        echo 'export PATH=$PATH:/usr/local/go/bin' >>  ~/.bashrc
fi
source ~/.bashrc

