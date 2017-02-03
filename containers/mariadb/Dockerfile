FROM mariadb:latest

MAINTAINER Dmitrii Larionov <dlarionov@hidglobal.com>

ADD ./my_config.cnf /etc/mysql/conf.d/
RUN chmod 0644 /etc/mysql/conf.d/my_config.cnf
COPY ./docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
#COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
