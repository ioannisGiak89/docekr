#!/bin/bash
set -e

POSTGRES="psql -v ON_ERROR_STOP=1 -U ${POSTGRES_USER} -d ${POSTGRES_DB}"

echo "==> Creating schema: ${SCHEMA}"
$POSTGRES <<-EOSQL
  CREATE SCHEMA IF NOT EXISTS ${SCHEMA} AUTHORIZATION ${POSTGRES_USER}
EOSQL

echo "==> Creating role: ${APPLICATION}_role"
$POSTGRES <<-EOSQL
  CREATE ROLE ${APPLICATION}_role;
EOSQL

echo "==> Creating user: ${APPLICATION}_1"
$POSTGRES <<-EOSQL
  CREATE ROLE ${APPLICATION}_1
  LOGIN PASSWORD '${POSTGRES_PASSWORD}'
  IN ROLE ${APPLICATION}_role;
EOSQL