#!/bin/bash
echo ""
echo "Docker container statuses:"

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

check_container "phpmyadmin" "phpmyadmin/phpmyadmin"
check_container "nginx     " "drupaldocker_nginx"
check_container "php       " "drupaldocker_php-fpm"
check_container "redis     " "redis:alpine"
check_container "grunt     " "drupaldocker_grunt"
check_container "mariadb   " "drupaldocker_mariadb"
check_container "solr3     " "drupaldocker_solr3"

echo ""

