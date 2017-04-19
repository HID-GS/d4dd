#!/bin/bash
echo ""
echo "D4DD Docker container statuses:"

DOCKERPS=$(docker ps)
function check_container() {
  CONTAINER="$1"
  IMAGE="$2"
  if [ $(echo "$DOCKERPS" | grep "$IMAGE" | wc -l) -gt 0 ]; then
    STATUS="running"
  else
    STATUS="stopped"
  fi
  echo "$CONTAINER - $STATUS"
}

check_container "jenkins            " "d4dd_jenkins"
check_container "nginx              " "d4dd_nginx"
check_container "utility-container  " "d4dd_utility-container"
check_container "php                " "d4dd_php-fpm"
check_container "phpmyadmin         " "phpmyadmin/phpmyadmin"
check_container "sonarqube          " "d4dd_sonarqube"
check_container "redis              " "redis:alpine"
check_container "mariadb            " "d4dd_mariadb"
check_container "solr3              " "d4dd_solr3"
check_container "postgres           " "postgres:alpine"
check_container "grunt              " "d4dd_grunt"

echo ""
