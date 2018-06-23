#!/bin/bash
set -e

POSTGRES="psql -v ON_ERROR_STOP=1 -U ${POSTGRES_USER} -d ${POSTGRES_DB}"

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

echo "==> Create ${APPLICATION}_role and grant connect privilege"
$POSTGRES <<-EOSQL
  CREATE ROLE ${APPLICATION}_role;
  GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO  ${APPLICATION}_role;
EOSQL

echo "==> Create ${SCHEMA}_read_role and grant connect privilege"
$POSTGRES <<-EOSQL
  CREATE ROLE ${SCHEMA}_read_role;
  GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO ${SCHEMA}_read_role;
EOSQL

echo "==> Create ${APPLICATION}_1 user"
$POSTGRES <<-EOSQL
  CREATE ROLE ${APPLICATION}_1
  LOGIN PASSWORD '${APPLICATION_USER_PWD}'
  IN ROLE ${APPLICATION}_role;
EOSQL

echo "==> Grant usage on schema ${SCHEMA} to ${APPLICATION}_role and ${SCHEMA}_read_role"
$POSTGRES <<-EOSQL
  GRANT USAGE ON SCHEMA ${SCHEMA} TO ${APPLICATION}_role;
  GRANT USAGE ON SCHEMA ${SCHEMA} TO ${SCHEMA}_read_role;
EOSQL

echo "==> Grant select on all tables in schema ${SCHEMA} to ${SCHEMA}_read_role"
$POSTGRES <<-EOSQL
  GRANT SELECT
  ON ALL TABLES IN SCHEMA ${SCHEMA}
  TO ${SCHEMA}_read_role;
EOSQL

echo "==> Set the search path for ${SCHEMA}_read_role and ${APPLICATION}_role"
$POSTGRES <<-EOSQL
  ALTER ROLE ${APPLICATION}_role SET search_path TO ${SCHEMA};
  ALTER ROLE ${SCHEMA}_read_role SET search_path TO ${SCHEMA};
EOSQL
