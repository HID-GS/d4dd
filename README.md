Created to be cloned within a subdirectory in your Drupal codebase. 
Will need to enter the cloned source directory in your Drupal branch's .gitignore.

This project requires phpcov which requires a newer version of phpunit than Drupal currently ships with.
```composer remove "phpunit/phpunit"```
```composer require --dev "phpunit/phpunit":"^5.1" "phpunit/phpcov":"^3.1"```

# php-local-docker-environment

## Preconfiguration for MacOS
1. ```gem install docker-sync```
2. ```brew install fswatch```
3. Update 'scr' variable in syncs section in docker-sync.yml file

## Configuration

1. After cloning this repo, at the project's root, make a local copy of the .env file: ```cp .env.default .env```
2. In the newly-created ```.env``` file, set ```DOCROOT``` to the root folder where your Drupal site exists
  * i.e. if your site is in ```project/web``` set the variable to ```web```
3. In the same ```.env``` file, set ```THEME``` to the folders where the site theme exists.
  * i.e., if your site theme exists at ```project/web/themes/custom_theme```. set the variable to ```themes/custom_theme```
4. For all other variables set ports to not conflict with existing used ports on your host machine
5. Create a new settings.php file based off of default.settings.php, and set the file's permissions to 777.
6. Add the following line at the bottom of settings.php:

```$config_directories['sync'] = 'sites/default/config/base';```

7. Access the Drupal install screen. When you get to the database information form, enter the following:

   ```
       database => project_db
       username => root
       password => secret
       host => mariadb
       port => 3306
       driver => mysql
   ```
#### If not on Linux you may need to do the following
1. In the ```.env``` file, modify ```HOST_IP``` to match an external IP
  * Leverage Peter's handy dandy script in order to find a likely IP:
    ```HOST_IP=$(ifconfig | awk '$0 ~ /inet / && $0 !~ /127.0.0.1/ {print $2; exit;}');```
2. Open your ```hosts``` file

## Run instructions(Linux)
1. ```docker-compose build```
2. ```docker-compose up -d```

To stop containers
* ```docker-compose down```
To stop containers and delete container data (will not delete the project files but will delete db and other information)
* ```docker-compose down -v```

### How to use
Access site at ```http://localhost:NGINX_HOST_HTTP_PORT```
Access jenkins at ```http://localhost:JENKINS_HOST_PORT```
Access sonarqube at ```http://localhost:SONARQUBE_HOST_PORT```
Access phpmyadmin at ```127.0.0.1:PMA_PORT```

## Run instructions(Mac)
1. ```docker-sync-stack start```

Alternatively:

1. ```docker-sync start```
2. In a new shell run after you started docker-sync 
   ```docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d```



## FAQ
### How to I populate the DB, once all the containers are up and running?
- Get a recent .sql file of the full DB, and run the following from the directory where the .sql file exists.
```docker exec -i d4dd_mariadb_1 mysql -uroot -psecret project_db < your.db.sql```

### How do a I run a ```drush``` command?
- Access the shell of the ```php-fpm``` container.
```
docker exec -i -t INSTANCE_NAME /bin/sh
```  
...where INSTANCE_NAME is replaced by the php-fpm instance name (ie, d4dd_php-fpm_1)
- Move to the desired instance's Drupal root directory.

Default: ```cd /var/www/drupal/web```

- Run the desired drush command.

```drush YOUR_COMMAND_HERE```

### How do I access the CLI on an instance?
-  Run 
```docker exec -i -t INSTANCE_NAME /bin/sh```  ..where INSTANCE_NAME is replaced by the instance name (ie, d4dd_php-fpm_1)

### I'm running these containers on a Linux box, and I've heard there's [a major security flaw](http://blog.viktorpetersson.com/post/101707677489/the-dangers-of-ufw-docker) inherent to using Docker on Linux. How do I secure the IP Tables? 
A handy guide can be found [here](https://svenv.nl/unixandlinux/dockerufw).

#### Start Docker without iptables
- create ```/lib/systemd/system/docker.service.d/noiptables.conf``` and fill it with the following info:
```
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon  --iptables=false
```
#### Modify the ufw rules
- In /etc/ufw/user.before, add the following rules above *filter:
```
*nat
:docker_postrouting - [0:0]
-A POSTROUTING -j docker_postrouting
-A docker_postrouting -s 172.16.0.0/12 ! -o br+ -j MASQUERADE
COMMIT
```
- In the same file, add the following before "COMMIT" at the bottom.
```
### DOCKER STUFF ###
-A FORWARD -i br+ -j ACCEPT

# for xdebug #
-A ufw-before-input -p tcp --dport 9000 -s 172.18.0.0/12 -j ACCEPT

### DOCKER END ###
```
### I tried to run ```docker-compose up -d``` and I got a strange error: ```No available IPv4 addresses on this network's address pools```. What gives?
- It may be because you have a VPN connection open. Please disconnect from the VPN & rerun ```docker-compose up -d```.
