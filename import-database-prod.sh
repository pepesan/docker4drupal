#!/bin/bash
# debug
set -o xtrace
source .env
echo "Volcando la BBDD"
export FILENAME=drupal-export.sql
cp sql/base/$FILENAME volumes-prod/mariadb-tmp
docker-compose -f docker-compose-prod.yaml exec -e FILENAME=$FILENAME mariadb-prod /bin/bash -c 'mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < "/tmp/${FILENAME}"'


