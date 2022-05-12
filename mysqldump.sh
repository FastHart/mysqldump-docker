#!/bin/bash

# == main program
# cath control-c
trap 'quit "Exit by SIGINT"'  INT
set -o pipefail

# Load env
WORK_DIR="$(dirname $0)"
if [ ${WORK_DIR} == '.' ]
then
  WORK_DIR=$(pwd)
fi
LOG_TAG="$0"
source ${WORK_DIR}/.functions.sh
source ${WORK_DIR}/mysqldump-docker.conf || err "Unable to load ${WORK_DIR}/.env"

# get arguments
if [ 0 -eq $# ]
  then
    quit "Usage: $0 <database>"
fi
DATABASE=$1
TIMESTAMP=`date +"%Y-%m-%d"`
FILENAME="${DATABASE}_${TIMESTAMP}.gz"

say "Starting dump database ${DATABASE} to ${BACKUPSTORE}/${FILENAME}"
LockSet
OUT=$({ /usr/bin/mysqldump -u ${DBUSER} --password=${DBPASS} ${DATABASE} | gzip - > ${BACKUPSTORE}/${FILENAME}; } 2>&1) || err "Unable to create dump: $OUT"
OUT=$(chown $BACKUP_OWNER ${BACKUPSTORE}/${FILENAME} 2>&1) || err "Unable to chown file: ${OUT}"
OUT=$(find $BACKUPSTORE -ctime +$RETENTION -delete 2>&1) || err "Unable to delete old files: ${OUT}"

quit "DONE!"
