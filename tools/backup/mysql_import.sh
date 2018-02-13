SQL_FILE=$1

set -e

function mysql_import {
  date_suffix=$(date +%Y-%m-%d-%H)
  docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'  ${DB_NAME} < $1
}



echo "Perform Import MySQL"
mysql_import $SQL_FILE

echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"
