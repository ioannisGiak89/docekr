FROM openjdk:8-jdk-alpine3.7
MAINTAINER Ioannis Giakoumidis <ioannis.giakoumidis@gmail.com>

RUN set -x \
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
    && sdk install grails 3.2.3 "
