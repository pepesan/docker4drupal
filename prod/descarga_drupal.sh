#!/bin/bash
mkdir drupal
#sudo chown -R 1000:1000 drupal
composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" drupal  --stability stable
mkdir drupal/web/sites/default/files
chmod a+w drupal/web/sites/default/files
mkdir drupal/web/sites/default/files/translations
chmod a+w drupal/web/sites/default/files/translations
#cp drupal/web/sites/default/default.settings.php drupal/web/sites/default/settings.php
cp settings.php drupal/web/sites/default/
chmod a+w  drupal/web/sites/default/settings.php
#sudo chown -R 1000:1000 drupal
#sudo chmod 775 -R drupal
