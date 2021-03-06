#!/bin/bash

compose_file_path=/root/start/docker-compose/web-data/docker-compose.yml

set -e

function backup_volume {
  volume_name=$1
  backup_destination=$2
  date_suffix=$(date +%Y-%m-%d-%H)

  docker run --rm -v $volume_name:/data -v $backup_destination:/backup ubuntu tar -zcvf /backup/$SERVER_NAME-$volume_name-$date_suffix.tar /data
}


echo "Stopping running MySQL && RocksDB container"
docker-compose -f $compose_file_path down --remove-orphans

# docker-compose -f $compose_file_path -p mysql stop
# docker-compose -f $compose_file_path -p rocksdb-server stop

echo "Perform backup MySQL"
backup_volume mysql_data /home/backup

echo "Perform backup RocksDB"
backup_volume rocksdb_data /home/backup

docker-compose -f $compose_file_path up -d
echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"
