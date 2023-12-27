#!/bin/bash

echo "Do you want to use a remote server for backup storage? (y/n)"
read MOUNT_CHOICE

if [ "$MOUNT_CHOICE" = "y" ]; then
    read -p "Enter remote server IP: " REMOTE_SERVER_IP
    REMOTE_DIR="/home/mysql_backup/"
    LOCAL_MOUNT_POINT="/var/lib/docker/volumes/mysql_backup/_data/remote"
    mkdir -p $LOCAL_MOUNT_POINT
    sshfs root@$REMOTE_SERVER_IP:$REMOTE_DIR $LOCAL_MOUNT_POINT
    BACKUP_BASE_DIR=$LOCAL_MOUNT_POINT
else
    BACKUP_BASE_DIR=/home/backup/mysql
fi

read -p "Enter DATABASE_PASSWORD: " DATABASE_PASSWORD
DATABASE_PASSWORD=$(echo $DATABASE_PASSWORD | xargs)
CURRENT_DATETIME=$(date +"%Y-%m-%d-%H-%M")

echo "Select backup method:"
echo "1) Full"
echo "2) Incremental"
read -p "Enter your choice (1 or 2): " BACKUP_METHOD

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

if [ "$CONFIRM_BACKUP" = "y" ]; then
    eval $XTRABACKUP_CMD
else
    echo "Backup aborted."
    exit 1
fi
