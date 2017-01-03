#!/usr/bin/env bash

cd /var/www/theme
npm update
bower install
bundle install
grunt
grunt watch