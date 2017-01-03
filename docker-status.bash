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
check_container "nginx     " "hiddockerd7_nginx"
check_container "php       " "hiddockerd7_php-fpm"
check_container "grunt     " "hiddockerd7_grunt"
check_container "mariadb   " "hiddockerd7_mariadb"
check_container "solr3     " "hiddockerd7_solr3"

echo ""

