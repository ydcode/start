#!/bin/bash

compose_file_path=/root/start/docker-compose/share-data/docker-compose.yml

set -e

function restore_volume {
  volume_name=$1
  backup_destination=$2
  file_name=$3

  docker run --rm -v $volume_name:/data ubuntu find /data -mindepth 1 -delete
  docker run --rm -v $volume_name:/data -v $backup_destination:/backup ubuntu tar -xvf /backup/$file_name -C .
}

echo "Stopping running MySQL && RocksDB container"

docker-compose -f $compose_file_path down --remove-orphans
# docker-compose -f $compose_file_path -p mysql stop
# docker-compose -f $compose_file_path -p rocksdb-server stop

echo "Perform Restore MySQL"
MySQL_FILE=`ls /home/backup/ | grep mysql`
restore_volume mysql_data /home/backup $MySQL_FILE

echo "Perform Restore RocksDB"
ROCK_FILE=`ls /home/backup/ | grep rocksdb`
restore_volume rocksdb_data /home/backup $ROCK_FILE

docker-compose -f $compose_file_path up -d

echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"




