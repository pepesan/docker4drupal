#!/bin/bash
set -eux
#./crea_imagen_prod.sh
sudo mkdir -p volumes-prod
sudo chmod 777 volumes-prod
sudo mkdir -p volumes-prod/mariadb-tmp
sudo chmod 777 volumes-prod/mariadb-tmp
sudo mkdir -p volumes-prod/logs
sudo chmod 777 volumes-prod/logs
docker-compose -f docker-compose-prod.yaml up -d
