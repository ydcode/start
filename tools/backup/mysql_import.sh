SQL_FILE=$1

set -e


echo "Perform Import MySQL"

if [ -z "$SQL_FILE" ]; then
    echo "./mysql_import.sh  sql_file"
fi

docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'  ${DB_NAME} < $SQL_FILE



echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"
