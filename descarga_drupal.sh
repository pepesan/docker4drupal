#!/bin/bash
source .env
composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" $DRUPAL_HOME  --stability stable --no-interaction
mkdir -p "${DRUPAL_HOME}/web/sites/default/files"
chmod a+w "${DRUPAL_HOME}/web/sites/default/files"
mkdir -p "${DRUPAL_HOME}/web/sites/default/files/translations"
chmod a+w "${DRUPAL_HOME}/web/sites/default/files/translations"
mkdir -p "${DRUPAL_HOME}/web/sites/default/files/tmp"
chmod a+w "${DRUPAL_HOME}/web/sites/default/files/tmp"
mkdir -p "${DRUPAL_HOME}/web/sites/default/files/sync"
chmod a+w "${DRUPAL_HOME}/web/sites/default/files/sync"
  #sudo cp drupal/web/sites/default/default.settings.php drupal/web/sites/default/settings.php
cp settings.php "${DRUPAL_HOME}/web/sites/default/"
chmod a+w  "${DRUPAL_HOME}/web/sites/default/settings.php"
  # sudo chown -R 1000:1000 drupal
  #sudo chmod 775 -R drupal
