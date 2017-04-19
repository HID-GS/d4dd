FROM laradock/workspace:1.3
MAINTAINER Nic Laflin <nic@nlighteneddevelopment.com>

#
#--------------------------------------------------------------------------
# Mandatory Software's Installation
#--------------------------------------------------------------------------
#
# Mandatory Software's such as ("php7.0-cli", "git", "vim", ....) are
# installed on the base image 'laradock/workspace' image. If you want
# to add more Software's or remove existing one, you need to edit the
# base image (https://github.com/LaraDock/workspace).
#

#
#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# Optional Software's will only be installed if you set them to `true`
# in the `docker-compose.yml` before the build.
# Example:
#   - INSTALL_NODE=false
#   - ...
#

#####################################
# Non-Root User:
#####################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g 1000 drupaldock && useradd -u 1000 -g drupaldock -m drupaldock

#####################################
# Set Timezone
#####################################

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#####################################
# Composer:
#####################################

# Add the composer.json
COPY ./composer.json /home/drupaldock/.composer/composer.json

# Make sure that ~/.composer belongs to drupaldock
RUN chown -R drupaldock:drupaldock /home/drupaldock/.composer
USER drupaldock

# Check if global install need to be ran
ARG COMPOSER_GLOBAL_INSTALL=false
ENV COMPOSER_GLOBAL_INSTALL ${COMPOSER_GLOBAL_INSTALL}
RUN if [ ${COMPOSER_GLOBAL_INSTALL} = true ]; then \
    # run the install
    composer global install \
;fi

# Export composer vendor path
RUN echo "" >> ~/.bashrc && \
echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc

#####################################
# ssh:
#####################################
ARG INSTALL_WORKSPACE_SSH=false
ENV INSTALL_WORKSPACE_SSH ${INSTALL_WORKSPACE_SSH}

ADD ./id_rsa_insecure.pub /tmp/id_rsa.pub

USER root

RUN if [ ${INSTALL_WORKSPACE_SSH} = true ]; then \
    rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys \
;fi

#####################################
# Drush:
#####################################
USER root
ENV DRUSH_VERSION 8.1.2
ARG INSTALL_DRUSH=false
ENV INSTALL_DRUSH ${INSTALL_DRUSH}
RUN if [ ${INSTALL_DRUSH} = true ]; then \
    # Install Drush 8 with the phar file.
    curl -fsSL -o /usr/local/bin/drush https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar | bash && \
    chmod +x /usr/local/bin/drush && \
    drush core-status \
;fi

USER drupaldock

#####################################
# Non-root user : PHPUnit path
#####################################

# add ./vendor/bin to non-root user's bashrc (needed for phpunit)
USER drupaldock

RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="/var/www/vendor/bin:$PATH"' >> ~/.bashrc

#####################################
# User Aliases
#####################################

USER drupaldock
COPY ./aliases.sh /home/drupaldock/aliases.sh
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/drupaldock/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc

USER root
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/drupaldock/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc

#####################################
# xDebug:
#####################################

USER root

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    # Load the xdebug extension only with phpunit commands
    apt-get update && \
    apt-get install -y --force-yes php7.0-xdebug && \
    sed -i 's/^/;/g' /etc/php/7.0/cli/conf.d/20-xdebug.ini \
;fi
# ADD for REMOTE debugging
COPY ./xdebug.ini /etc/php/7.0/cli/conf.d/xdebug.ini

#####################################
# mariadb client:
#####################################

USER root
RUN apt-get install -y mariadb-client

#####################################
# test structure:
#####################################
ARG DEFAULT_TEST_CONFIG=false

RUN mkdir -p /var/www/tests
COPY ./tests /var/www/tests

RUN if [ ${DEFAULT_TEST_CONFIG} = true ]; then \
#Use Default Config
    mkdir /var/www/tests/config && \
    cp -a /var/www/tests/sample_config/. /var/www/tests/config \
;fi

COPY ./entrypoint.bash /bin/entrypoint.bash

RUN chmod +x /bin/entrypoint.bash

ENTRYPOINT ["/bin/entrypoint.bash"]