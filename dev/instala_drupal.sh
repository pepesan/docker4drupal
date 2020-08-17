#!/bin/bash
source .env
docker-compose exec -u root app chown -R www:www /var/www
#echo "instalando en mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DB_HOST}/${MYSQL_DATABASE}"
echo "instalando en mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${DB_HOST}/${MYSQL_DATABASE}"
docker-compose exec -u www-data \
    -e DB_HOST=$DB_HOST \
    -e DB_USER=$MYSQL_USER \
    -e DB_PASSWORD_$MYSQL_PASSWORD \
    -e DB_NAME=$MYSQL_DATABASE \
    -e ADMIN_PASSWORD=$ADMIN_PASSWORD \
    -e PROJECT_NAME=$PROJECT_NAME \
    app drush \
    -r /var/www \
    si standard \
    --locale=es \
    --account-name=$ADMIN_ACCOUNT \
    --account-pass=$ADMIN_PASSWORD \
    --account-mail=$ADMIN_EMAIL \
    --site-name=$PROJECT_NAME \
    -y \
    --debug
