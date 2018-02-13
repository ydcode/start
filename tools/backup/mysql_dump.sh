compose_file_path=/home/gce/start/docker-compose/share-data/docker-compose.yml

set -e

function mysql_dump {
  backup_destination=$1
  date_suffix=$(date +%Y-%m-%d-%H)
  docker exec mysql sh -c 'exec mysqldump --databases '${DB_NAME}' -uroot -p"$MYSQL_ROOT_PASSWORD"'  > $backup_destination/$DB_NAME_$date_suffix.sql
}


echo "Stopping running MySQL && RocksDB container"
docker-compose -f $compose_file_path down --remove-orphans

echo "Perform Dump MySQL"
mysql_dump /home/backup

echo "Starting MySQL && RocksDB container"
docker-compose -f $compose_file_path up -d
echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"




