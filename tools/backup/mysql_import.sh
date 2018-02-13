SQL_FILE=$1

set -e

function mysql_import {
  docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'  ${DB_NAME} < ${SQL_FILE}
}



echo "Perform Import MySQL"
mysql_import

echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"
