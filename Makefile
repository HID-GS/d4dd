docker-rebuild:
	docker-compose stop
	docker-compose build
docker-restart:
	docker-compose stop
	docker-compose up -d
db-download:
	sh getdb.sh
db-import:
	mysql -h 0.0.0.0 -u root -psecret homestead < data/backups/HIDGlobal.mysql
db-configure:
	docker-compose exec php-fpm drush updb -y
	docker-compose exec php-fpm drush en -y language_domains stage_file_proxy maillog views_ui update
	docker-compose exec php-fpm drush dis -y memcache memcache_admin redis
	docker-compose exec php-fpm drush vset error_level 2
#docker-drush:
#	docker-compose run drush $(filter-out $@,$(MAKECMDGOALS))
docker-drush:
	docker-compose exec php-fpm drush $(filter-out $@,$(MAKECMDGOALS))