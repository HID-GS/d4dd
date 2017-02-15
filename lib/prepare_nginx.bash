#!/bin/bash

# Resetting old config
rm -rf data/config/sites/*conf 2> /dev/null

config_file='lib/nginx_template.conf'
nginx_folder='data/config/sites'
for site in sites.d/*.yml; do
  echo "Processing nginx config for $site"
  site_name="$(gawk -f lib/prepare_nginx_name.awk $site)"
  site_aliases="$(gawk -f lib/prepare_nginx_aliases.awk $site)"
  cat $config_file | \
    sed  -e 's/%%site_name%%/'"$site_name"'/g' \
         -e 's/%%site_aliases%%/'"$site_aliases"'/g' > "$nginx_folder/$site_name.conf"
done