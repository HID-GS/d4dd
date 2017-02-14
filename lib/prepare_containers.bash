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
if [ $(grep HOST_IP .env 2> /dev/null | wc -l) -gt 0 ]; then
  sed -i.bak -e 's/HOST_IP=.*/HOST_IP='"$HOST_IP"'/g' .env
else
  echo "" >> .env
  echo "HOST_IP='$HOST_IP'" >> .env
fi

echo "host ip set to $HOST_IP"
echo "user set to $USER"

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
