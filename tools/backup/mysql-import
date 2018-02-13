compose_file_path=/home/gce/start/docker-compose/share-data/docker-compose.yml

set -e

function mysql_import {
  sql_file=$1
  date_suffix=$(date +%Y-%m-%d-%H)
  docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'  ${DB_NAME} < $sql_file
}


SQL_FILE=`ls /home/backup/ | grep [.]sql`

echo "Perform Import MySQL"
mysql_import SQL_FILE

echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"
