#!/bin/bash
set -e

POSTGRES="psql -v ON_ERROR_STOP=1 -U ${POSTGRES_USER} -d ${POSTGRES_DB}"

if [ -z "${APPLICATION}" ]
then
    APPLICATION=${POSTGRES_DB}
fi

if [ -z "${SCHEMA}" ]
then
    SCHEMA=${POSTGRES_DB}
fi

if [ -z "${APPLICATION_USER_PWD}" ]
then
    APPLICATION_USER_PWD=${POSTGRES_PASSWORD}
fi

echo "==> Revoking create on public schema from public"
$POSTGRES <<-EOSQL
  REVOKE CREATE ON SCHEMA PUBLIC FROM PUBLIC;
EOSQL

echo "==> Revoking create on public schema from ${POSTGRES_USER} user"
$POSTGRES <<-EOSQL
  REVOKE CREATE ON SCHEMA PUBLIC FROM ${POSTGRES_USER};
EOSQL

echo "==> Revoking all privileges on ${POSTGRES_DB} database from public"
$POSTGRES <<-EOSQL
  REVOKE ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} FROM PUBLIC;
EOSQL

echo "==> Creating schema ${SCHEMA}"
$POSTGRES <<-EOSQL
  CREATE SCHEMA IF NOT EXISTS ${SCHEMA} AUTHORIZATION ${POSTGRES_USER}
EOSQL

echo "==> Alter user ${POSTGRES_USER} so he can create new users"
$POSTGRES <<-EOSQL
  ALTER USER ${POSTGRES_USER} CREATEUSER;
EOSQL

echo "==> Alter user ${POSTGRES_USER} so he can create new roles"
$POSTGRES <<-EOSQL
  ALTER USER ${POSTGRES_USER} CREATEROLE;
EOSQL

echo "==> Create ${APPLICATION} role and grant connect privilege"
$POSTGRES <<-EOSQL
  CREATE ROLE ${APPLICATION};
  GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO  ${APPLICATION};
EOSQL

echo "==> Create ${SCHEMA}_read and grant connect privilege"
$POSTGRES <<-EOSQL
  CREATE ROLE ${SCHEMA}_read;
  GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO ${SCHEMA}_read;
EOSQL

echo "==> Create ${APPLICATION}_1 user"
$POSTGRES <<-EOSQL
  CREATE ROLE ${APPLICATION}_1
  LOGIN PASSWORD '${APPLICATION_USER_PWD}'
  IN ROLE ${APPLICATION};
EOSQL

echo "==> Grant usage on schema ${SCHEMA} to ${APPLICATION} and ${SCHEMA}_read"
$POSTGRES <<-EOSQL
  GRANT USAGE ON SCHEMA ${SCHEMA} TO ${APPLICATION};
  GRANT USAGE ON SCHEMA ${SCHEMA} TO ${SCHEMA}_read;
EOSQL

echo "==> Grant select on all tables in schema ${SCHEMA} to ${SCHEMA}_read"
$POSTGRES <<-EOSQL
  GRANT SELECT
  ON ALL TABLES IN SCHEMA ${SCHEMA}
  TO ${SCHEMA}_read;
EOSQL

echo "==> Set the search path for ${SCHEMA}_read and ${APPLICATION}"
$POSTGRES <<-EOSQL
  ALTER ROLE ${APPLICATION} SET search_path TO ${SCHEMA};
  ALTER ROLE ${SCHEMA}_read SET search_path TO ${SCHEMA};
EOSQL
