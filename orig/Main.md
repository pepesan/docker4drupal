# Revisión de Docker4Drupal

Descargado de [Repositorio Docker4Drupal](https://github.com/wodby/docker4drupal)

Revisionado en [Repositorio pepesan Docker4Drupal](https://github.com/pepesan/docker4drupal)

# Requisitos
* Docker
* docker-compose
# Arraque de los servicios
<code>docker-compose up -d</code>
# Descarga de drupal
* mkdir drupal
* composer create-project drupal/recommended-project drupal
# Instalación de Drupal
nota: 1001 es el propietario y grupo de la carpeta
# Docker compose exec
<code>docker-compose exec -u 1001 -e DB_HOST=$DB_HOST -e DB_USER=$DB_USER -e DB_PASSWORD_$DB_PASSWORD -e DB_NAME=$DB_NAME -e ADMIN_PASSWORD=$ADMIN_PASSWORD php drush -r /var/www/html/web si standard --db-url=mysql://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME --account-pass=$ADMIN_PASSWORD
</code>
  
