docker exec mysql sh -c 'exec mysqldump --databases '${DB_NAME}' -uroot -p"$MYSQL_ROOT_PASSWORD"'  > $DB_NAME_`date +%Y-%m-%d-%H-%M`.sql.sql
