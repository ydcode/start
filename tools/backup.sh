#!/bin/bash

compose_file_path=$1
project_name=${2,,}
backup_path=$3
backup_or_restore=$4
restore_date=$5

set -e


function backup_volume {
  volume_name=$1
  backup_destination=$2
  date_suffix=$(date +%Y-%m-%d-%H)

  docker run --rm -v $volume_name:/data -v $backup_destination:/backup ubuntu tar -zcvf /backup/$DASHBOARD_DOMAIN-$volume_name-$date_suffix.tar /data
}

function restore_volume {
  volume_name=$1
  backup_destination=$2
  date=$3

  docker run --rm -v $volume_name:/data ubuntu find /data -mindepth 1 -delete
  docker run --rm -v $volume_name:/data -v $backup_destination:/backup ubuntu tar -xvf /backup/$volume_name-$date.tar -C .
}

echo "Stopping running mysql container"
docker-compose -f /home/gce/start/docker-compose/share-data/docker-compose.yml -p mysql stop

echo "Perform backup MySQL"
backup_volume mysql_data /home/backup

echo "Perform backup RocksDB"
backup_volume rocksdb_data /home/backup


 "-------------------------------------------------------------------------------"
ls -al /home/backup/
