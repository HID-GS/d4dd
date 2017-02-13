#!/bin/bash

echo ""
echo "Setting up environment variables"
# Setup variables in .env file
# Setup USER variable
if [ $(grep 'USER' .env 2> /dev/null | wc -l ) -eq 0 ]; then
  echo "" >> .env;
  echo "USER=$USER" >> .env;
fi

# setup HOST_IP variable
HOST_IP=$(ifconfig | awk '$0 ~ /inet / && $0 !~ /127.0.0.1/ {print $2; exit;}');
sed -i.bak -e 's/HOST_IP=.*/HOST_IP='"$HOST_IP"'/g' .env

# Setup docker-compose-volumes.yml file
TEMP_FILE="lib/docker-compose-volumes.yml";
echo "version: '2'"     > $TEMP_FILE;
echo 'services:'       >> $TEMP_FILE;
echo '  volumes-only:' >> $TEMP_FILE;
echo '    volumes:'    >> $TEMP_FILE;
gawk -f lib/prepare_volumes.awk sites.d/*yml | sed "s/'//g" >> $TEMP_FILE

echo "Done."
echo ""
echo "Preparing docker containers."
echo "This could take a while on its first run."
echo ""

docker-compose build > /dev/null
echo ""
if [ $(echo $?) -ne 0 ]; then
  echo "OOPS! Something went wrong..."
else
  echo "Your stack is ready to be started."
  echo "Run 'docker-compose up -d' to get going."
fi
echo ""
