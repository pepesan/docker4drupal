#!/bin/bash
set -eux
./descarga_drupal.sh
sudo mkdir volumes
sudo chmod 777 volumes
sudo mkdir volumes/mariadb-tmp
sudo chmod 777 volumes/mariadb-tmp
docker-compose up -d
sleep 10
./instala_drupal.sh
