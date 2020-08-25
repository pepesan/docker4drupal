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

#Solr and server by module
docker-compose exec -u www-data \
  app composer \
  require \
  -d /var/www \
  drupal/search_api_solr pepesan/search_api_solr_custom_server
#docker-compose exec -u www-data \
#  app drush  -y \
#  en search_api_solr search_api_solr_defaults
docker-compose exec -u www-data \
  app drush  -y \
  en search_api_solr search_api_solr_custom_server
# Disable Page cache and big_pipe for varnish and search for solr
docker-compose exec -u www-data \
  app drush  -y \
  pmu page_cache big_pipe search
# Install varnish
#docker-compose exec -u www-data \
#  app composer \
#  require \
#  -d /var/www \
#  drupal/purge drupal/varnish_purge  drupal/adv_varnish
docker-compose exec -u www-data \
  app composer \
  require \
  -d /var/www \
  drupal/adv_varnish

#docker-compose exec -u www-data \
#  app drush  -y \
#  en purge purge_drush purge_tokens purge_ui purge_processor_cron purge_processor_lateruntime purge_queuer_coretags varnish_purger varnish_purge_tags adv_varnish

docker-compose exec -u www-data \
  app drush  -y \
  en adv_varnish

docker-compose exec \
  solr \
  solr create_core -c drupal -d /opt/solr/server/solr/drupal
# Locale management
docker-compose exec -u www-data \
  app drush  -y \
  locale-check
docker-compose exec -u www-data \
  app drush  -y \
  locale-update
docker-compose exec -u www-data \
  app drush  -y \
  updatedb-status
# Drush Cron
docker-compose exec -u www-data \
  app drush  -y \
  cron
./backup-database.sh

sudo chmod 775 settings.php
