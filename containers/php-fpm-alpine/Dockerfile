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
ARG HOST_IP
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    # Install the xdebug extension
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

# ADD for REMOTE debugging
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
# inserting new line, just in case .ini file doesn't end with a new line
RUN echo -e "\nxdebug.remote_host=$HOST_IP" >> /usr/local/etc/php/conf.d/xdebug.ini

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
		echo 'error_log=/var/log/php_errors.log'; \
		echo 'log_errors=1'; \
		echo 'error_reporting=E_ALL'; \
		echo 'auto_detect_line_endings=1'; \
		echo 'max_execution_time = 300'; \
		echo 'upload_max_filesize = 50M'; \
		echo 'post_max_size = 50M'; \
	} > /usr/local/etc/php/conf.d/develop-settings.ini

# Drush:
# Get a global installation of Drush on the web / drupal container
RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush && chmod +x drush && mv drush /usr/local/bin

# ensure www-data user exists
RUN if [ $(grep www-data /etc/passwd | wc -l) -eq 0 ]; then \
        set -x; \
        addgroup -g 82 -S www-data; \
        adduser -u 82 -D -S -G www-data www-data; \
    fi;

# Composer
ARG INSTALL_COMPOSER=false
RUN if [ ${INSTALL_COMPOSER} = true ]; then \
		php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
		&& php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
		&& php composer-setup.php \
		&& php -r "unlink('composer-setup.php');" \
		&& mv composer.phar /usr/local/bin/composer \
;fi

#Drupal console
ARG INSTALL_DRUPAL_CLI=false
RUN if [ ${INSTALL_DRUPAL_CLI} = true ]; then \
		php -r "readfile('https://drupalconsole.com/installer');" > drupal.phar \
		&& mv drupal.phar /usr/local/bin/drupal \
		&& chmod +x /usr/local/bin/drupal \
;fi

# Delete packages
RUN apk del libtool autoconf gcc g++ make && \
  rm -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /var/www/drupal/${DOCROOT}
WORKDIR /var/www/drupal/${DOCROOT}

EXPOSE 9000

CMD ["php-fpm"]
