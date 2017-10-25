FROM ubuntu:xenial

COPY provisioning/docker-entrypoint.sh /opt/php-setup/docker-entrypoint.sh

ENV GOSU_VERSION 1.10
ENV PHP_UID 1000
ENV PHP_GID 1000
ENV PHP_HOME /home/php
ENV PHP_WORKDIR /app

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git-core \
        language-pack-en-base \
        openssh-client \
        software-properties-common \
        wget \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && LC_ALL=en_US.UTF-8 apt-add-repository ppa:ondrej/php \
    && curl -sL "https://deb.nodesource.com/setup_8.x" > /tmp/install-node.sh \
    && bash /tmp/install-node.sh \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
        imagemagick \
        nodejs \
        yarn \
    && apt-get install -y --no-install-recommends \
        php7.1 \
        php7.1-cli \
        php7.1-common \
        php7.1-curl \
        php7.1-dev \
        php7.1-fpm \
        php7.1-gd \
        php7.1-imagick \
        php7.1-intl \
        php7.1-json \
        php7.1-mcrypt \
        php7.1-memcached \
        php7.1-mysql \
        php7.1-xml \
        php7.1-zip \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/app/lists/* \
    && chmod +x /opt/php-setup/docker-entrypoint.sh

WORKDIR /opt/php-setup

ENTRYPOINT ["/opt/php-setup/docker-entrypoint.sh"]

CMD ["php", "-v"]
