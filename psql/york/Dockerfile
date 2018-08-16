FROM postgres:9.5

ENV SCHEMA ${SCHEMA}
ENV APPLICATION ${APPLICATION}
ENV APPLICATION_USER_PWD ${APPLICATION_USER_PWD}

COPY provisioning/docker-entrypoint.sh /docker-entrypoint-initdb.d/init-user-db.sh
