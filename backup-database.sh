#!/bin/bash
# debug
#set -o xtrace
source .env
echo "Volcando la BBDD"
export TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S-%N")
#docker-compose exec -e TIMESTAMP=$TIMESTAMP mariadb /bin/bash -c 'mysqldump --opt -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > "/tmp/${MYSQL_DATABASE}-${TIMESTAMP}.sql"'
docker-compose exec -e TIMESTAMP=$TIMESTAMP app /bin/bash -c 'drush sql:dump > "/tmp/drupal-export-${TIMESTAMP}.sql"'
docker-compose exec -e TIMESTAMP=$TIMESTAMP app /bin/bash -c 'drush sql:dump > "/tmp/drupal-export.sql"'
#echo "Volcando Ficheros de Drupal"
#docker-compose exec -e TIMESTAMP=$TIMESTAMP app /bin/bash -c 'drush archive-dump default --tar-options="--exclude=.git --exclude=sites/default/files" --destination="/tmp/drupal-${TIMESTAMP}.tar"'

