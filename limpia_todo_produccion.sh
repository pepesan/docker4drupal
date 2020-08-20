#!/bin/bash

docker-compose -f docker-compose-prod.yaml down
docker images prune -a
docker volume prune -f
sudo rm -rf volumes-prod
