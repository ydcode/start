#!/bin/bash

compose_file_path=/home/gce/start/docker-compose/share-data/docker-compose.yml

set -e

function restore_volume {
  volume_name=$1
  backup_destination=$2

  docker run --rm -v $volume_name:/data ubuntu find /data -mindepth 1 -delete
  docker run --rm -v $volume_name:/data -v $backup_destination:/backup ubuntu tar -xvf /backup/*$volume_name-*.tar -C .
}

echo "Stopping running MySQL && RocksDB container"
docker-compose -f $compose_file_path -p mysql stop
docker-compose -f $compose_file_path -p rocksdb-server stop

echo "Perform Restore MySQL"
restore_volume mysql_data /home/backup

echo "Perform Restore RocksDB"
restore_volume rocksdb_data /home/backup



echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"



