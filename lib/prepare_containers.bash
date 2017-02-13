#!/bin/bash

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
