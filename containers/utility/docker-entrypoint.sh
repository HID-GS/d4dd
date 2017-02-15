#!/bin/sh

if [ -f /utility/init.sql ]; then
  mysql -h db -u $mariadb_USERNAME -p$mariadb_ROOT_PASSWORD < /utility/init.sql
fi
