FROM openjdk:8-jdk-alpine3.7
MAINTAINER Ioannis Giakoumidis <ioannis.giakoumidis@gmail.com>

COPY provisioning/docker-entrypoint.sh /opt/grails-setup/docker-entrypoint.sh

ENV GRAILS_OPTS="-XX:-UseSplitVerifier -Xverify:none"
ENV GRAILS_UID 1000
ENV GRAILS_GID 1000
ENV GRAILS_HOME /home/grails
ENV GRAILS_WORKDIR /app
ENV PATH ${PATH}:/usr/local/sdkman/candidates/grails/current/bin
ENV SDKMAN_DIR="/usr/local/sdkman"

ARG grails_version

RUN set -x \
    && mkdir /app \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
        curl \
        zip \
        unzip \
        bash \
    && bin/bash -c "set -x \
    && curl -s 'https://get.sdkman.io' | bash \
    && source '/usr/local/sdkman/bin/sdkman-init.sh' \
    && sdk install grails $grails_version" \
    && chmod +x /opt/grails-setup/docker-entrypoint.sh

EXPOSE 8080
EXPOSE 5005

ENTRYPOINT ["/opt/grails-setup/docker-entrypoint.sh"]
