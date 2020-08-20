#!/bin/bash
# debug
# set -o xtrace
source .env
echo "Volcando la BBDD"
export TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S-%N")
docker-compose exec -e TIMESTAMP=$TIMESTAMP mariadb /bin/bash -c 'mysqldump --opt -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > "/tmp/${MYSQL_DATABASE}-${TIMESTAMP}.sql"'
