#!/bin/bash

Create_Database()
{
    read -p "DEnter Database UserName:(default bootDB) " DatabaseUserName
    read -p "DEnter Database UserName:(default bootDB) " DatabasePassword


    mysql -u root -e "create database testdb";


}


Database_Choice()
{
	DatabaseChoice="y"
	Echo_Yellow "----------------------------------------------------"
	Echo_Yellow "Create Database?"


    read -p "Default Yes,Enter your choice [Y/n]: " DatabaseChoice
	
	case "${DatabaseChoice}" in
    [yY][eE][sS]|[yY])
        echo "You will Add Database"
        DatabaseChoice="y"
        ;;
    [nN][oO]|[nN])
        echo "No Database"
        DatabaseChoice="n"
        ;;
    *)
        echo "No input,You will add  Database"
        DatabaseChoice="y"
    esac
	
	
	if [ "${DatabaseChoice}" = "y" ]; then		
		Create_Database
    else
		Echo_Yellow "Choose No Database"
    fi
	
	
}

Database_Choice