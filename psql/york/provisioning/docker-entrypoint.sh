#!/bin/bash
set -e

POSTGRES="psql -v ON_ERROR_STOP=1 -U ${POSTGRES_USER} -d ${POSTGRES_DB}"

echo "==> Revoking create on public schema from public"
$POSTGRES <<-EOSQL
  REVOKE CREATE ON SCHEMA PUBLIC FROM PUBLIC;
EOSQL

echo "==> Revoking create on schema public from ${POSTGRES_DB} database"
$POSTGRES <<-EOSQL
  REVOKE CREATE ON SCHEMA PUBLIC FROM ${POSTGRES_DB};
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
