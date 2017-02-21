# php-local-docker-environment

## Preconfiguration for MacOS
1. ```gem install docker-sync```
2. ```brew install fswatch```
3. Update 'scr' variable in syncs section in docker-sync.yml file

## Configuration

1. After cloning this repo, at the project's root, make a local copy of the .env file: ```cp .env.default .env```
2. In the newly-created ```.env``` file, set ```PROJECTS_PATH``` to the root folder where your Drupal sites exist
  * i.e., if your Drupal site exists at ```/var/www/hid/old_site```. set the variable to ```/var/www/hid```
3. In the same ```.env``` file, set ```HID_D7``` and ```DRUPAL_8``` to the folders where the site exists.
  * i.e., if your D7 Drupal site exists at ```/var/www/hid/old_site```. set the variable to ```old_site```
4. In the same ```.env``` file, modify ```HOST_IP``` to match (...what? local IP? 0.0.0.0?) 
5. Open your ```hosts``` file
6. For each ```${PROJECT}.conf``` file in containers/nginx/sites folder...
 1. Find the ```server_name``` entry
  2. In your ```hosts``` file, add an entry mapping the ```HOST_IP``` to the ```server_name```
7. Add the following DB configuration in settings.php

   D7:
   ```
   $databases = array(
     'default' =>
      array(
       'default' =>
       array(
         'database' => 'hidglobal',
         'username' => 'hidglobal',
         'password' => 'secret',
         'host' => 'mariadb',
         'port' => '3306',
         'driver' => 'mysql',
         'prefix' => '',
       ),
     ),
   );
   ```


   D8:
   ```
   $databases['default']['default'] = array (
       'database' => 'default',
       'username' => 'user',
       'password' => 'password',
       'prefix' => '',
       'host' => 'mariadb',
       'port' => '3306',
       'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
       'driver' => 'mysql',
   );
   ```


## Run instructions(Linux)
1. ```docker-compose build```
2. ```docker-compose up -d```

## Run instructions(Mac)
1. ```docker-sync-stack start6```

Alternatively:

1. ```docker-sync start```
2. In a new shell run after you started docker-sync 
   ```docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d```



## FAQ
### How to I populate the DB, once all the containers are up and running?
- Get a recent .sql file of the full DB, and run the following from the directory where the .sql file exists.
```docker exec -i d7hid_mariadb_1 mysql -uroot -psecret hidglobal < hidglobal.db.sql```

### How do a I run a ```drush``` command?
-  Run a ```docker exec``` which points at the ```d7hid_php-fpm_1``` container. I.e.,
```docker exec -i d7hid_php-fpm_1 drush cc all```

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
