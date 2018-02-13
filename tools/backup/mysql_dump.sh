
set -e

function mysql_dump {
  volume_name=$1
  backup_destination=$2
  date_suffix=$(date +%Y-%m-%d-%H)
  docker exec mysql sh -c 'exec mysqldump --databases '${DB_NAME}' -uroot -p"$MYSQL_ROOT_PASSWORD"'  > $DB_NAME_`date +%Y-%m-%d-%H-%M`.sql.sql
}


echo "Stopping running MySQL && RocksDB container"
docker-compose -f $compose_file_path down --remove-orphans

echo "Perform Dump MySQL"
mysql_dump mysql_data /home/backup

docker-compose -f $compose_file_path up -d
echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"




