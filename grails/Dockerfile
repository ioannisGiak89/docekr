FROM tomcat:9-jdk11-slim
MAINTAINER Ioannis Giakoumidis <ioannis.giakoumidis@gmail.com>

COPY provisioning/docker-entrypoint.sh /opt/grails-setup/docker-entrypoint.sh
COPY context/template.xml /tmp/template.xml

ENV GRAILS_OPTS="-XX:-UseSplitVerifier -Xverify:none"
ENV GRAILS_UID 1000
ENV GRAILS_GID 1000
ENV GRAILS_HOME /home/grails
ENV GRAILS_WORKDIR /app

RUN set -x \
    && mkdir /app \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        curl \
        zip \
        unzip \
    && chmod +x /opt/grails-setup/docker-entrypoint.sh

EXPOSE 8080
EXPOSE 5005

ENTRYPOINT ["/opt/grails-setup/docker-entrypoint.sh"]
