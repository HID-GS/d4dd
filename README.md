# php-local-docker-environment

## Preconfiguration for MacOS
1. ```gem install docker-sync```
2. ```brew install fswatch```
3. Update 'scr' variable in syncs section in docker-sync.yml file

## Configuration

1. ```cp .env.default .env```
2. Set the path to your projects folder in .env file
3. Configure ${PROJECT}.conf file in containers/nginx/sites folder
4. Add records to /etc/hosts file	
5. Example DB configuration in settings.php

```
$databases = array(
  'default' =>
  array(
    'default' =>
    array(
      //'database' => 'hid_brand_family',
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


## Run instructions(Linux)
1. ```docker-compose build```
2. ```docker-compose up -d```

## Run instructions(Mac)
1. ```docker-sync-stack start```

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
#### Start Docker without iptables
- create ```/lib/systemd/system/docker.service.d/noiptables.conf``` and fill it with the following info:
```
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon  --iptables=false
```
#### Modify the ufw rules
- In /etc/ufw/user.rules, add the following rules:
```
*nat
:docker_postrouting - [0:0]
-A POSTROUTING -j docker_postrouting
-A docker_postrouting -s 172.16.0.0/12 ! -o br+ -j MASQUERADE
COMMIT

### DOCKER STUFF ###
-A FORWARD -i br+ -j ACCEPT
### DOCKER END ###
```
### I tried to run ```docker-compose up -d``` and I got a strange error: ```No available IPv4 addresses on this network's address pools```. What gives?
- It may be because you have a VPN connection open. Please disconnect from the VPN & rerun ```docker-compose up -d```.