#!/bin/bash
set -eux
./descarga_drupal.sh
sudo mkdir -p volumes
sudo chmod 777 volumes
sudo mkdir -p volumes/mariadb-tmp
sudo chmod 777 volumes/mariadb-tmp
sudo mkdir -p volumes/app-tmp
sudo chmod 777 volumes/app-tmp
docker-compose up -d
sleep 10
./instala_drupal.sh
echo "Entra a http://localhost/"
