SQL_FILE=$1

set -e

if [ -z "$SQL_FILE" ]; then

    echo "usage: mysql_import.sh  ***.sql"
    exit 0
fi
echo "Perform Import MySQL"

docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" bootdb < $SQL_FILE'

echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
ls -lh /home/backup/
echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"
