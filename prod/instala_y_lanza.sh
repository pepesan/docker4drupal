#!/bin/bash
./descarga_drupal.sh
docker-compose up -d
sleep 10
./instala_drupal.sh
