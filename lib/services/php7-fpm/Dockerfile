FROM php:7.0-fpm
MAINTAINER Dmitrii Larionov <dlarionov@hidglobal.com>

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev libmagickwand-dev mariadb-client \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql zip

RUN pecl install imagick \
  && docker-php-ext-enable imagick \
  && rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
		echo 'memory_limit=512M'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# set develop PHP.ini settings
RUN { \
		echo 'error_log = /var/log/php_errors.log'; \
		echo 'log_errors = 1'; \
		echo 'error_reporting = E_ALL'; \
	} > /usr/local/etc/php/conf.d/develop-settings.ini

# Drush:
# Get a global installation of Drush on the web / drupal container
RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush && chmod +x drush && mv drush /usr/local/bin

RUN usermod -u 1000 www-data

WORKDIR /var/www/hidglobal/hid

CMD ["php-fpm"]

EXPOSE 9000