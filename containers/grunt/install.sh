#!/usr/bin/env bash

cd /var/www/drupal/${THEME}
npm update
bower install
bundle install
grunt
grunt watch