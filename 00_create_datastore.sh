#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "ckan" <<-EOSQL
    CREATE ROLE datastore_ro NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'datastore';
    CREATE DATABASE datastore OWNER ckan ENCODING 'utf-8';
    GRANT ALL PRIVILEGES ON DATABASE datastore TO ckan;
EOSQL
