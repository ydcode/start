#!/bin/bash

CONFIG_FILE="/tmp/backup_config.txt"

setup_sshfs() {
    if [ -f $CONFIG_FILE ]; then
        . $CONFIG_FILE
        echo "Current remote server IP: $REMOTE_SERVER_IP"
        echo "Enter new remote server IP or press enter to use current [$REMOTE_SERVER_IP]:"
        read NEW_REMOTE_SERVER_IP
        NEW_REMOTE_SERVER_IP=$(echo $NEW_REMOTE_SERVER_IP | xargs)
        if [ -n "$NEW_REMOTE_SERVER_IP" ]; then
            REMOTE_SERVER_IP=$NEW_REMOTE_SERVER_IP
        fi
        echo "REMOTE_SERVER_IP=$REMOTE_SERVER_IP" > $CONFIG_FILE
    else
        read -p "Enter remote server IP: " REMOTE_SERVER_IP
        REMOTE_SERVER_IP=$(echo $REMOTE_SERVER_IP | xargs)
        REMOTE_DIR="/home/temp_transfer"
        LOCAL_MOUNT_POINT="/var/lib/docker/volumes/mysql_backup/_data/remote"

        echo "REMOTE_SERVER_IP=$REMOTE_SERVER_IP" > $CONFIG_FILE
        echo "REMOTE_DIR=$REMOTE_DIR" >> $CONFIG_FILE
        echo "LOCAL_MOUNT_POINT=$LOCAL_MOUNT_POINT" >> $CONFIG_FILE
    fi

    sudo apt-get install -y sshfs
    mkdir -p $LOCAL_MOUNT_POINT
    sshfs root@$REMOTE_SERVER_IP:$REMOTE_DIR $LOCAL_MOUNT_POINT
}

echo "Do you want to use a remote server for backup storage? (y/n)"
read MOUNT_CHOICE
MOUNT_CHOICE=$(echo $MOUNT_CHOICE | xargs)

if [ "$MOUNT_CHOICE" = "y" ]; then
    setup_sshfs
    BACKUP_BASE_DIR=$LOCAL_MOUNT_POINT
else
    BACKUP_BASE_DIR=/home/backup/mysql
fi

echo "Select backup method:"
echo "1) Full"
echo "2) Incremental"
read -p "Enter your choice (1 or 2): " BACKUP_METHOD
BACKUP_METHOD=$(echo $BACKUP_METHOD | xargs)

if [ -f $CONFIG_FILE ]; then
    . $CONFIG_FILE
    echo "Current database password."
    echo "Enter new DATABASE_PASSWORD or press enter to use current:"
    read -s NEW_DATABASE_PASSWORD
    NEW_DATABASE_PASSWORD=$(echo $NEW_DATABASE_PASSWORD | xargs)
    if [ -n "$NEW_DATABASE_PASSWORD" ]; then
        DATABASE_PASSWORD=$NEW_DATABASE_PASSWORD
    fi
    echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" > $CONFIG_FILE
else
    read -s -p "Enter DATABASE_PASSWORD: " DATABASE_PASSWORD
    DATABASE_PASSWORD=$(echo $DATABASE_PASSWORD | xargs)
    echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" >> $CONFIG_FILE
fi

CURRENT_DATETIME=$(date +"%Y-%m-%d-%H-%M")

case $BACKUP_METHOD in
    1)
        echo "Full backup selected."
        BACKUP_DIR="full_$CURRENT_DATETIME"
        ;;
    2)
        echo "Incremental backup selected."
        BACKUP_DIR="incremental_$CURRENT_DATETIME"
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

XTRABACKUP_CMD="xtrabackup --backup --user=root --password=$DATABASE_PASSWORD --target-dir=$BACKUP_BASE_DIR/$BACKUP_DIR"
echo "The following command will be executed:"
echo $XTRABACKUP_CMD

read -p "Are you sure you want to proceed with the backup? (y/n): " CONFIRM_BACKUP
CONFIRM_BACKUP=$(echo $CONFIRM_BACKUP | xargs)

if [ "$CONFIRM_BACKUP" = "y" ]; then
    docker exec -it mysql bash -c "apt-get update && apt-get install -y wget curl sudo lsb-release && wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb && sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb && sudo percona-release setup ps80 && sudo apt-get update && sudo apt-get install -y percona-xtrabackup-80"
    docker exec -it mysql bash -c "$XTRABACKUP_CMD"

else
    echo "Backup aborted."
    exit 1
fi
