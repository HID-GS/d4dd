#! /bin/bash

cp -a /var/www/tests/. /var/www/drupal/tests
rm -rf /var/www/tests

/sbin/my_init