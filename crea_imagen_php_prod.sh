#!/bin/bash
set -eux
source .env
echo "Creando Imagen php fpm:${DOCKER_IMAGE_PROD}"
pwd
docker build -t ${DOCKER_IMAGE_PROD} -f ./Dockerfile.prod .
#    --no-cache
echo "Logueando"
docker login
echo "Subiendo la imagen al repo"
docker push $DOCKER_IMAGE_PROD

