#!/bin/bash

docker-compose down
docker images prune -a
docker volume prune
sudo rm -rf volumes drupal
