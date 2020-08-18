#!/bin/bash
mkdir drupal
sudo chown -R 1000:1000 drupal
sudo composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" drupal  --stability stable
sudo mkdir drupal/web/sites/default/files
sudo chmod a+w drupal/web/sites/default/files
sudo mkdir drupal/web/sites/default/files/translations
sudo chmod a+w drupal/web/sites/default/files/translations
#sudo cp drupal/web/sites/default/default.settings.php drupal/web/sites/default/settings.php
sudo cp settings.php drupal/web/sites/default/
sudo chmod a+w  drupal/web/sites/default/settings.php
sudo chown -R 1000:1000 drupal
#sudo chmod 775 -R drupal
