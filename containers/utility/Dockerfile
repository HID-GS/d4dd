FROM alpine:latest
MAINTAINER Peter Carrero <peter.carrero@gmail.com>

RUN { \
  apk update; \
  apk add mariadb-client; \
}

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
