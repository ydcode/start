#!/bin/bash

#REMOTE_SERVER_IP=
#rsync -avz --progress /home/temp_transfer/ root@$REMOTE_SERVER_IP:/home/temp_transfer/


docker rm -f mysql
apt-get update && apt-get install -y wget curl sudo lsb-release && wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb && sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb && sudo percona-release setup ps80 && sudo apt-get update && sudo apt-get install -y percona-xtrabackup-80

xtrabackup --prepare --target-dir=/home/temp_transfer/full_2023-12-27-05-00
rm -rf /var/lib/docker/volumes/mysql_data/_data/*

#dataDir Realy Path, Not Docker Volume Path
xtrabackup --copy-back --target-dir=/home/temp_transfer/full_2023-12-27-05-00 --datadir=/var/lib/docker/volumes/mysql_data/_data
