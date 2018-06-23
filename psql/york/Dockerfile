FROM postgres:9.5

ENV SCHEMA ${POSTGRES_DB}
ENV APPLICATION ${POSTGRES_DB}
ENV APPLICATION_USER_PWD ${POSTGRES_PASSWORD}

COPY provisioning/docker-entrypoint.sh /docker-entrypoint-initdb.d/init-user-db.sh
