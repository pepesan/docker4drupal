#!/bin/bash

docker-compose down
docker images prune -a
docker volume prune -f
sudo rm -rf volumes ./drupal
