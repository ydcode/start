#!/bin/bash

CONFIG_FILE="/tmp/backup_config.txt"
REMOTE_DIR="/home/temp_transfer"

FULL_BACKUP_PREFIX="full_"
INCREMENTAL_BACKUP_PREFIX="incremental_"

get_latest_full_backup() {
    local latest_backup=$(ls -1d $BACKUP_BASE_DIR/${FULL_BACKUP_PREFIX}* 2>/dev/null | sort -r | head -n 1)
    if [ -n "$latest_backup" ]; then
        echo "$latest_backup"
    else
        return 1
    fi
}

setup_database_password() {
    if [ -f $CONFIG_FILE ]; then
        . $CONFIG_FILE
        if [ -n "$DATABASE_PASSWORD" ]; then
            echo "Current DATABASE_PASSWORD: $DATABASE_PASSWORD"
            echo "Do you want to use the current password? (y/n)"
            read USE_CURRENT_PW_CHOICE
            USE_CURRENT_PW_CHOICE=$(echo $USE_CURRENT_PW_CHOICE | xargs)

            if [ "$USE_CURRENT_PW_CHOICE" != "y" ]; then
                echo "Enter new DATABASE_PASSWORD:"
                read -s DATABASE_PASSWORD
                DATABASE_PASSWORD=$(echo $DATABASE_PASSWORD | xargs)
                echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" > $CONFIG_FILE
            fi
        else
            echo "Enter DATABASE_PASSWORD:"
            read -s DATABASE_PASSWORD
            DATABASE_PASSWORD=$(echo $DATABASE_PASSWORD | xargs)
            echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" > $CONFIG_FILE
        fi
    else
        echo "Enter DATABASE_PASSWORD:"
        read -s DATABASE_PASSWORD
        DATABASE_PASSWORD=$(echo $DATABASE_PASSWORD | xargs)
        echo "DATABASE_PASSWORD=$DATABASE_PASSWORD" > $CONFIG_FILE
    fi
}


BACKUP_BASE_DIR=/home/backup/mysql

echo "Select backup method:"
echo "1) Full"
echo "2) Incremental"
read -p "Enter your choice (1 or 2): " BACKUP_METHOD
BACKUP_METHOD=$(echo $BACKUP_METHOD | xargs)

setup_database_password

CURRENT_DATETIME=$(date +"%Y-%m-%d-%H-%M")

case $BACKUP_METHOD in
    1)
        echo "Full backup selected."
        BACKUP_DIR="${FULL_BACKUP_PREFIX}${CURRENT_DATETIME}"
        ;;
    2)
        echo "Incremental backup selected."
        LATEST_FULL_BACKUP_DIR=$(get_latest_full_backup)

        if [ $? -ne 0 ]; then
            echo "No full backup found. Incremental backup requires a full backup. Aborting."
            exit 1
        fi
        BACKUP_DIR="${INCREMENTAL_BACKUP_PREFIX}${CURRENT_DATETIME}"
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

mkdir -p $BACKUP_BASE_DIR/$BACKUP_DIR

XTRABACKUP_CMD="xtrabackup --backup --user=root --password=$DATABASE_PASSWORD --target-dir=$BACKUP_BASE_DIR/$BACKUP_DIR"

XTRABACKUP_CMD+=" --tables-exclude='command_control.data_ebay_search2' --tables-exclude='command_control.logs_command_control_request_log'"

if [ "$BACKUP_METHOD" = "2" ]; then
    XTRABACKUP_CMD="$XTRABACKUP_CMD --incremental-basedir=$LATEST_FULL_BACKUP_DIR"
fi

echo "The following command will be executed:"
echo $XTRABACKUP_CMD

read -p "Are you sure you want to proceed with the backup? (y/n): " CONFIRM_BACKUP
CONFIRM_BACKUP=$(echo $CONFIRM_BACKUP | xargs)

if [ "$CONFIRM_BACKUP" = "y" ]; then
    docker exec -it mysql bash -c "apt-get update && apt-get install -y wget curl sudo lsb-release && wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb && sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb && sudo percona-release setup ps80 && sudo apt-get update && sudo apt-get install -y percona-xtrabackup-80"
    docker exec -it mysql bash -c "$XTRABACKUP_CMD"

    docker exec -it mysql bash -c "ls -al $BACKUP_BASE_DIR"
    docker exec -it mysql bash -c "ls -al $BACKUP_BASE_DIR/$BACKUP_DIR"

    docker exec -it mysql bash -c "echo 'Docker Inner Backup Directory: $BACKUP_BASE_DIR/$BACKUP_DIR'"
    docker exec -it mysql bash -c "echo 'RemoteServer Backup Directory: $REMOTE_DIR'"

else
    echo "Backup aborted."
    exit 1
fi
