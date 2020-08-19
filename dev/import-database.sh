#!/bin/bash
# debug
# set -o xtrace
source .env
echo "Volcando la BBDD"
export FILENAME=drupal-export.sql
docker-compose exec -e FILENAME=$FILENAME mariadb /bin/bash -c 'mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < "/tmp/${FILENAME}"'
