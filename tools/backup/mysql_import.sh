set -e

echo "Perform Import MySQL"
SQL_FILE=$1


Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}


Import_Data(){
	echo "****************"
	echo $SQL_FILE
	docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" bootdb < $SQL_FILE'

	echo "---------------------------------------------------------------------------ls -lh /home/backup/---------------------"
	ls -lh /home/backup/
	echo "---------------------------------------------------------------------------cd /home/backup/-------------------------"
}


Import_Choice()
{
	ImportChoice="n"
	Echo_Red "Import Data (Danger!!!)?"
	read -p "Default No,Enter your choice [y/N]: " ImportChoice

	case "${ImportChoice}" in
	[yY][eE][sS]|[yY])
		echo "You will import Data"
		ImportChoice="y"
		;;
	[nN][oO]|[nN])
		echo "No JDK && MVN"
		ImportChoice="n"
		;;
	*)
	esac

	if [ "${ImportChoice}" = "y" ]; then
		echo "-----------------"
		echo $SQL_FILE

		Import_Data
	else
		Echo_Yellow "Choose Not Import"
	fi
}



if [ -z "$SQL_FILE" ]; then
	echo "usage: mysql_import.sh  ***.sql"
	exit 0
fi
	
Import_Choice




