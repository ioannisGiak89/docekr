ARG psql_version=latest

FROM postgres:$psql_version

COPY provisioning/docker-entrypoint.sh /docker-entrypoint-initdb.d/init-user-db.sh
