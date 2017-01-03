# php-local-docker-environment

## Configuration

1. ```cp .env.default .env```
2. Set the path to your projects folder in .env file
3. Configure ${PROJECT}.conf file in containers/nginx/sites folder
4. ```docker-compose build```
5. ```docker-compose up -d```
6. Add records to /etc/hosts file