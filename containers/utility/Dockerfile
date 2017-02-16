FROM alpine:latest
MAINTAINER Peter Carrero <peter.carrero@gmail.com>

RUN { \
  apk update; \
  apk add mariadb-client openssh; \
  ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''; \
  ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N ''; \
  ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ''; \
  ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''; \
}

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
