#!/bin/bash
USER=$(getent passwd grails 2>&1)
GROUP=$(getent group grails 2>&1)

echo "==> Attempting to create 'grails' user."

if [ ${#USER} == 0 ] && [ ${#GROUP} == 0 ]; then
    # Create the user with the given home directory.
    echo "    Creating user with UID:GID of ${GRAILS_UID}:${GRAILS_GID}"
    groupadd -g ${GRAILS_GID} grails
    adduser -q --system --disabled-password --shell /bin/bash --uid ${GRAILS_UID} --gid ${GRAILS_GID} --home ${GRAILS_HOME} grails
else
    echo "    User 'grails' already exists."
fi

echo "==> Attempting to create home directory at '${GRAILS_HOME}'."
# Create the home directory, if it doesn't already exist. We won't bother with the skeleton.
if [ ! -d "${GRAILS_HOME}" ]; then
    mkdir -p "${GRAILS_HOME}"
    echo "    Done!"
else
    echo "    Already exists!"
fi

echo "==> Fixing permissions"
chown -R ${GRAILS_UID}:${GRAILS_GID} "${GRAILS_HOME}"
chown -R ${GRAILS_UID}:${GRAILS_GID} "${GRAILS_WORKDIR}"
echo "    Done!"

echo "==> Attempting to create ${CONTEXT_BASE_FILE_NAME} context"
if [ ! -f "${CATALINA_HOME}/conf/Catalina/localhost/${CONTEXT_BASE_FILE_NAME}.xml" ]; then
    sed -i "s/{{CONTEXT_PATH}}/$(echo "${CONTEXT_PATH}")/g"  /tmp/template.xml
    sed -i "s/{{CONTEXT_BASE_FILE_NAME}}/${CONTEXT_BASE_FILE_NAME}/g" /tmp/template.xml
    mkdir -p "${CATALINA_HOME}/conf/Catalina/localhost/"
    cp /tmp/template.xml "${CATALINA_HOME}/conf/Catalina/localhost/${CONTEXT_BASE_FILE_NAME}.xml"
    echo "    Done!"
else
    echo "    Already exists!"
fi

if [ ${RUN_APP} = true ]; then
    # su grails -c "./gradlew --continuous bootRun"
    chown -R ${GRAILS_UID}:${GRAILS_GID} ${CATALINA_HOME}
    su grails -c "sh /usr/local/tomcat/bin/catalina.sh run"
else
    echo "==> Use 'docker exec -it -u grails <container_name> bash' to log into the container and create your app"
    tail -f /dev/null
fi
