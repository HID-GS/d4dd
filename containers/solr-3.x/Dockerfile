FROM  java:openjdk-8-jre-alpine
MAINTAINER Dmitrii Larionov <dlarionov@hidglobal.com>

# Override the solr download location with e.g.:
#   docker build -t mine --build-arg SOLR_DOWNLOAD_SERVER=http://www-eu.apache.org/dist/lucene/solr .
ARG SOLR_DOWNLOAD_SERVER

RUN apk add --no-cache \
        lsof \
        gnupg \
        procps \
        tar \
        bash
RUN apk add --no-cache ca-certificates wget && \
        update-ca-certificates

ENV SOLR_USER solr
ENV SOLR_UID 8983

RUN addgroup -S -g $SOLR_UID $SOLR_USER && \
  adduser -S -u $SOLR_UID -g $SOLR_USER $SOLR_USER

ENV SOLR_VERSION 3.6.2
ENV SOLR_SHA1 3a1a40542670ea6efec246a081053732c5503ec1
ENV SOLR_URL ${SOLR_DOWNLOAD_SERVER:-https://archive.apache.org/dist/lucene/solr}/$SOLR_VERSION/apache-solr-$SOLR_VERSION.tgz

RUN mkdir -p /opt/solr && \
  echo "downloading $SOLR_URL" && \
  wget -q $SOLR_URL -O /opt/solr.tgz && \
  echo "downloading $SOLR_URL.asc" && \
  wget -q $SOLR_URL.asc -O /opt/solr.tgz.asc && \
  echo "$SOLR_SHA1 */opt/solr.tgz" | sha1sum -c - && \
  (>&2 ls -l /opt/solr.tgz /opt/solr.tgz.asc) && \
  tar -C /opt/solr --extract --file /opt/solr.tgz --strip-components=1 && \
  rm /opt/solr.tgz* && \
  rm -Rf /opt/solr/docs/

COPY ./3.x/* /opt/solr/example/solr/conf/

EXPOSE 8983
WORKDIR /opt/solr/example
ENTRYPOINT ["java"]
CMD ["-Xmx512m", "-DSTOP.PORT=8079", "-DSTOP.KEY=stopkey", "-jar", "start.jar"]