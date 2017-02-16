#!/bin/bash

# Resetting old config

mkdir -p data/config/sites 2> /dev/null
rm -rf data/config/sites/*conf 2> /dev/null

mkdir -p data/config/utility 2> /dev/null
rm -rf data/config/utility/* 2> /dev/null

config_file='lib/nginx_template.conf'
nginx_folder='data/config/sites'
utility_folder='data/config/utility'
utility_file="$utility_folder/init.sql"
for site in sites.d/*.yml; do
  echo "Processing nginx config for $site"
  site_name="$(gawk -f lib/prepare_nginx_name.awk $site)"
  site_aliases="$(gawk -f lib/prepare_nginx_aliases.awk $site)"
  database="$(gawk -f lib/prepare_db_file.awk $site | sed 's#~#'$HOME'#g')"
  if [[ -f $database ]] && [[ ! $database == data/* ]]; then
    cp $database data/$site_name.sql
  fi
  cat $config_file | \
    sed  -e 's/%%site_name%%/'"$site_name"'/g' \
         -e 's/%%site_aliases%%/'"$site_aliases"'/g' > "$nginx_folder/$site_name.conf"
  echo "CREATE DATABASE IF NOT EXISTS $site_name;" >> $utility_file
  echo "GRANT ALL ON $site_name.* to docker@localhost identified by 'docker';" >> $utility_file
  echo "GRANT ALL ON $site_name.* to docker@\`%\` identified by 'docker';" >> $utility_file
done