compose_file_path=/root/start/docker-compose/share-data/docker-compose.yml

set -e

function mysql_dump {
  backup_destination=$1
  date_suffix=$(date +%Y-%m-%d-%H)
  docker exec mysql sh -c 'exec mysqldump --databases '${DB_NAME}' --no-create-db -uroot -p"$MYSQL_ROOT_PASSWORD"'  > $backup_destination/${DB_NAME}-${COUNTRY}-$date_suffix.sql
}

echo "Perform Dump MySQL"
mysql_dump /home/backup

echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"




