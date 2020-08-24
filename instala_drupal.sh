#!/bin/bash
source .env
set -eux
#docker-compose exec app pwd
#docker-compose exec app composer -d../ update
#docker-compose exec app composer -d../ install

docker-compose exec -u root app chown -R www-data:www-data /var/www
#echo "instalando en mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DB_HOST}/${MYSQL_DATABASE}"
echo "instalando en mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DB_HOST}/${MYSQL_DATABASE}"

#Dependencies installation: redis, bootstrap theme
docker-compose exec -u www-data \
  app composer \
  require \
  -d /var/www \
  drupal/bootstrap drupal/redis predis/predis

docker-compose exec -u www-data \
    -e DB_HOST=$DB_HOST \
    -e DB_USER=$MYSQL_USER \
    -e DB_PASSWORD_$MYSQL_PASSWORD \
    -e DB_NAME=$MYSQL_DATABASE \
    -e ADMIN_PASSWORD=$ADMIN_PASSWORD \
    -e PROJECT_NAME=$PROJECT_NAME \
    app drush \
    si standard \
    --locale=es \
    --account-name=$ADMIN_ACCOUNT \
    --account-pass=$ADMIN_PASSWORD \
    --account-mail=$ADMIN_EMAIL \
    --site-name=$PROJECT_NAME \
    -y \
    --debug
docker-compose exec -u www-data \
  app drush -y \
  en bootstrap redis
docker-compose exec -u www-data \
  app drush  -y \
  config:set system.theme default bootstrap
docker-compose exec -u www-data \
  app drush  -y \
  updatedb-status
./backup-database.sh

sudo chmod 775 settings.php
