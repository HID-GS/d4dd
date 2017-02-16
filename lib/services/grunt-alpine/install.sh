#!/bin/sh

cd /var/www/hidglobal/hid/sites/all/themes/hidglobal
npm update
bower install
bundle install
grunt
grunt watch