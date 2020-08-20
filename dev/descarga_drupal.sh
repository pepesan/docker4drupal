#!/bin/bash
export DRUPAL_HOME=../drupal
composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" $DRUPAL_HOME  --stability stable
mkdir "${DRUPAL_HOME}/web/sites/default/files"
chmod a+w "${DRUPAL_HOME}/web/sites/default/files"
mkdir "${DRUPAL_HOME}/web/sites/default/files/translations"
chmod a+w "${DRUPAL_HOME}/web/sites/default/files/translations"
#sudo cp drupal/web/sites/default/default.settings.php drupal/web/sites/default/settings.php
cp settings.php "${DRUPAL_HOME}/web/sites/default/"
chmod a+w  "${DRUPAL_HOME}/web/sites/default/settings.php"
# sudo chown -R 1000:1000 drupal
#sudo chmod 775 -R drupal
