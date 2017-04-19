#!/bin/bash

TEST_DB=${TEST_DB:-mysql://root:@mariadb/project_db}
GROUP=${GROUP:-drupaldock}

BASE_PATH=/var/www/drupal/web
BASE_URL=http://nginx:80

mkdir -p /var/www/drupal/tests/coverage
COVERAGE_ARGS=(--configuration /var/www/drupal/tests/config/phpunit.xml.dist --coverage-clover /var/www/drupal/tests/coverage-report/clover.xml --log-junit /var/www/drupal/tests/coverage-report/junit.xml)

BROWSERTEST_OUTPUT_FILE=/var/www/drupal/tests/coverage-report/browser-output.html SIMPLETEST_DB=$TEST_DB SIMPLETEST_BASE_URL=$BASE_URL /var/www/drupal/vendor/bin/phpunit ${COVERAGE_ARGS[@]}


/var/www/drupal/vendor/bin/phpcov merge /var/www/drupal/tests/coverage --html /var/www/drupal/tests/coverage-report/
