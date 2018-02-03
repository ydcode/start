#!/bin/bash

compose_file_path=$1
project_name=${2,,}
backup_path=$3
backup_or_restore=$4
restore_date=$5

set -e
