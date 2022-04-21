### mysqldump-docker

Simple script for backup mysql database running in docker container.  
Intended to be to run from cron.

This script do the follows:

- Create gzipped mysqldump named as ${DATABASE}_${TIMESTAMP}.gz in ${BACKUPSTORE} directory
- Delete dumps older than ${RETENTION} days
- Write output to syslog

### Usage:

1. Create mysqldump-docker.conf file from example mysqldump-docker.conf.sample
2. Run mysqldump-docker.sh [container_name] [database]
