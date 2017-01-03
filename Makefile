help:
## This help message
	@echo ""
	@echo "Available commands:"
	@sed -ne 's/^\([^#][^ ]*:\)/ \1/gp'  -ne 's/^##/  --/gp' < Makefile
	@echo ""
docker-rebuild:
## Rebuilds docker container farm
	docker-compose stop
	docker-compose build
	docker-compose up -d
docker-restart:
## Restarts docker containers
	docker-compose stop
	docker-compose up -d
db-download:
## Downloads new database file from dev2
	sh getdb.sh
db-import:
## Imports new db into container 
	@echo "Deploying new database"
	@pv data/backups/HIDGlobal.mysql | mysql -h 127.0.0.1 -u root -psecret hidglobal 2> /dev/null
db-configure:
## Configures new db into container 
	docker-compose exec php-fpm drush updb -y
	docker-compose exec php-fpm drush en -y language_domains stage_file_proxy maillog views_ui update
	docker-compose exec php-fpm drush dis -y memcache memcache_admin redis
	docker-compose exec php-fpm drush vset error_level 2
#docker-drush:
#	docker-compose run drush $(filter-out $@,$(MAKECMDGOALS))
docker-drush:
## Runs drush in php container
	docker-compose exec php-fpm drush $(filter-out $@,$(MAKECMDGOALS))
