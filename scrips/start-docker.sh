#!/bin/bash

cd docker

echo "CKAN_PORT=8096" >> .env

echo "POSTGRES_PASSWORD=ckan" >> .env

echo "SYSADMIN_PASS=tM5c=^MP" >> .env

echo "POSTGRES_PORT=5432" >> .env

echo "DATASTORE_READONLY_PASSWORD=datastore" >> .env

echo "HOST_FQN=$1" >> .env

docker-compose up -d --build

sleep 15

until docker exec -it postgresql psql -U 'ckan' -c '\q'; do
        >&2 echo "Postgres is unavailable - sleeping"
        sleep 15
done

>&2 echo "Postgres is up - setting up ckan and enabling datapusher"

sleep 15

docker-compose restart ckan

sleep 15

cd ..