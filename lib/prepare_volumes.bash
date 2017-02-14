#!/bin/bash



# Setup docker-compose-volumes.yml file
echo ""
echo "Setting up volumes..."
TEMP_FILE="lib/docker-compose-volumes.yml";
echo "version: '2'"     > $TEMP_FILE;
echo 'services:'       >> $TEMP_FILE;
echo '  volumes-only:' >> $TEMP_FILE;
echo '    volumes:'    >> $TEMP_FILE;
gawk -f lib/prepare_volumes.awk sites.d/*yml | sed "s/'//g" >> $TEMP_FILE

echo "Done."
echo ""
