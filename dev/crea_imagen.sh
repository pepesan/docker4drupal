#!/bin/bash
source .env
echo "Creando Imagen ${DOCKER_IMAGE}"
docker build -t $DOCKER_IMAGE .
#    --no-cache
echo "Logeuando"
docker login
echo "Subiendo la imagen al repo"
docker push $DOCKER_IMAGE