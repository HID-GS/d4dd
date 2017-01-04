FROM ruby:latest
MAINTAINER Dmitrii Larionov <dlarionov@hidglobal.com>

RUN apt-get -y update && \
    apt-get -y install npm

# Install sass and compass gems
RUN gem install compass --no-ri --no-rdoc && \
    gem install bundler --no-ri --no-rdoc

RUN npm install -g n bower grunt-cli phantomjs-prebuilt
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN n 0.10.48
RUN mkdir /src
RUN mkdir -p /var/www/theme
COPY ./install.sh /src
RUN chmod +x /src/install.sh

WORKDIR /var/www/theme
ENTRYPOINT ["/src/install.sh"]
