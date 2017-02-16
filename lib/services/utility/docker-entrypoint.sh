#!/bin/sh

if [ -f /utility/init.sql ]; then
  echo "Creating databases that do not yet exit"
  mysql -h db -u $mariadb_USERNAME -p$mariadb_ROOT_PASSWORD < /utility/init.sql
  echo "Done."
fi

echo "Starting ssh daemon"
/usr/sbin/sshd -D
