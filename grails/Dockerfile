FROM openjdk:8-jdk-alpine3.7
MAINTAINER Ioannis Giakoumidis <ioannis.giakoumidis@gmail.com>

COPY provisioning/docker-entrypoint.sh /opt/grails-setup/docker-entrypoint.sh

ENV GRAILS_OPTS="-XX:-UseSplitVerifier -Xverify:none"
ENV GRAILS_UID 1000
ENV GRAILS_GID 1000
ENV GRAILS_HOME /home/grails
ENV GRAILS_WORKDIR /app

RUN set -x \
    && mkdir /app \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
        curl \
        zip \
        unzip \
        bash \
    && chmod +x /opt/grails-setup/docker-entrypoint.sh

ENTRYPOINT ["/opt/grails-setup/docker-entrypoint.sh"]
