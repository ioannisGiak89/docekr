FROM openjdk:8-jdk-alpine3.7
MAINTAINER Ioannis Giakoumidis <ioannis.giakoumidis@gmail.com>

ARG grails_version

RUN set -x \
    && mkdir /app \
    && apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && bin/bash -c "set -x \
    && apk add --no-cache \
        curl \
        zip \
        unzip \
    && curl -s 'https://get.sdkman.io' | bash \
    && source '/root/.sdkman/bin/sdkman-init.sh' \
    && sdk version \
    && sdk install grails $grails_version "

EXPOSE 8080
EXPOSE 5005
