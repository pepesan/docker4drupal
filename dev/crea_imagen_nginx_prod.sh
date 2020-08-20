#!/bin/bash
source .env
echo "Creando Imagen nginx:${DOCKER_IMAGE_NGINX_PROD}"
docker build -t $DOCKER_IMAGE_NGINX_PROD -f ./Dockerfile.nginx .
#    --no-cache
echo "Logueando"
docker login
echo "Subiendo la imagen al repo"
docker push $DOCKER_IMAGE_NGINX_PROD

