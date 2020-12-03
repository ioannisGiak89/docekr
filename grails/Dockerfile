FROM tomcat:8-jre8-alpine
MAINTAINER Ioannis Giakoumidis <ioannis.giakoumidis@gmail.com>

COPY provisioning/docker-entrypoint.sh /opt/grails-setup/docker-entrypoint.sh
COPY context/template.xml /tmp/template.xml

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
        postgresql-client \
    && /bin/bash -c "set -x \
    && curl -s 'https://get.sdkman.io' | bash \
    && source '/usr/local/sdkman/bin/sdkman-init.sh' \
    && sdk install grails $grails_version" \
    && sed -i 's/webapps/\/app\/build\/libs/g' /usr/local/tomcat/conf/server.xml \
    && chmod +x /opt/grails-setup/docker-entrypoint.sh

EXPOSE 8080
EXPOSE 5005

ENTRYPOINT ["/opt/grails-setup/docker-entrypoint.sh"]
