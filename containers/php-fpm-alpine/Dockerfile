FROM php:7.0-fpm-alpine
MAINTAINER Dmitrii Larionov <dlarionov@hidglobal.com>

RUN apk update \
		&& apk add --no-cache libjpeg-turbo-dev libpng-dev imagemagick-dev libtool autoconf gcc g++ make mariadb-client

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
		&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql zip

RUN pecl install imagick \
    && docker-php-ext-enable imagick

#####################################
# xDebug:
#####################################

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    # Install the xdebug extension
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

RUN { \
		echo 'xdebug.remote_enable=on'; \
    echo 'xdebug.remote_autostart=off'; \
    echo 'xdebug.remote_port=9001'; \
    echo 'xdebug.remote_host=172.19.0.1'; \
  } > /usr/local/etc/php/conf.d/xdebug.ini

# ensure www-data user exists

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

RUN if [ $(grep www-data /etc/passwd | wc -l) -eq 0 ]; then \
        set -x; \
        addgroup -g 82 -S www-data; \
        adduser -u 82 -D -S -G www-data www-data; \
    fi;

# Delete packages
RUN apk del libtool autoconf gcc g++ make && \
  rm -rf /etc/ssl /tmp/* /var/cache/apk/*

WORKDIR /var/www/hidglobal/hid

EXPOSE 9000

CMD ["php-fpm"]