#!/bin/sh

cd /var/www/drupal/${DOCROOT}/${THEME}
npm update
bower install
bundle install
grunt
grunt watch