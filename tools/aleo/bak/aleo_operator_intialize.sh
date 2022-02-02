#!/bin/bash

mkdir -p /home/nugget && cd /home/nugget
git clone https://github.com/HarukaMa/snarkOS --depth 1
cd snarkOS
./testnet2_ubuntu.sh

#以下手动
source ~/.bashrc
mkdir -p /root/.aleo/storage && cd /root/.aleo/storage/

wget http://52.224.238.136:1989/ledger.tar.gz
tar -zvxf ledger.tar.gz

cd /home/nugget/snarkOS


cargo run --release -- --operator ${MINER_ADDRESS} --trial --verbosity 2