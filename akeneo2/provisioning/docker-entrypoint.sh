#!/usr/bin/env bash

USER=$(getent passwd php 2>&1)
GROUP=$(getent group php 2>&1)

echo "==> Attempting to create 'php' user."

if [ ${#USER} == 0 ] && [ ${#GROUP} == 0 ]; then
    # Create the user with the given home directory.
    echo "    Creating user with UID:GID of ${PHP_UID}:${PHP_GID}"
    groupadd -g ${PHP_GID} -o php
    useradd -s /bin/bash -u ${PHP_UID} -g ${PHP_GID} -d ${PHP_HOME} -M -o php
else
    echo "    User 'php' already exists."
fi


echo "==> Attempting to create home directory at '${PHP_HOME}'."

# Create the home directory, if it doesn't already exist. We won't bother with the skeleton.
if [ ! -d "${PHP_HOME}" ]; then
    mkdir -p "${PHP_HOME}"
    echo "    Done!"
else
    echo "    Already exists!"
fi

echo "==> Attempting to create working directory at '${PHP_WORKDIR}'."

# Create the workspace.
if [ ! -d "${PHP_WORKDIR}" ]; then
    mkdir -p "${PHP_WORKDIR}"
    echo "    Done!"
else
    echo "    Already exists!"
fi

echo "==> Updating home and working directory permissions..."

chown ${PHP_UID}:${PHP_GID} "${PHP_HOME}"
chown ${PHP_UID}:${PHP_GID} "${PHP_WORKDIR}"

echo "    Done!"

echo "==> Running CMD..."

cd "${PHP_WORKDIR}"

exec gosu php "$@"
