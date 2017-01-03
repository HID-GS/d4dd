#!/usr/bin/env bash
PATH="/usr/local/bin:$PATH"
export PATH

SEMAPHORE='/tmp/db_copy.txt'
if [ -f $SEMAPHORE ]; then
  echo "process is already in progress" | terminal-notifier
  exit 1
fi

REMOTEFILE='/var/local/backups/hidglobal.db.sql.gz'
REMOTESERVER='dev2.hid.gl'
WORKFOLDER="$HOME/workspace/docker-php-stack/data/backups"
LOCALFILE="$WORKFOLDER/HIDGlobal.mysql"

touch $SEMAPHORE
day=$(date +%Y-%m-%d_T_%H-%M-%S)
mv $WORKFOLDER/HIDGlobal.mysql{,-$day}
gzip $WORKFOLDER/HIDGlobal.mysql-$day
ssh $REMOTESERVER cat $REMOTEFILE | zcat > $LOCALFILE

rm -f $SEMAPHORE