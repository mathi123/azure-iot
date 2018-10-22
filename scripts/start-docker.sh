#!/bin/bash

cd docker

echo "CKAN_PORT=8096" >> .env

echo "POSTGRES_PASSWORD=ckan" >> .env

echo "SYSADMIN_PASS=tM5c=^MP" >> .env

echo "POSTGRES_PORT=5432" >> .env

echo "DATASTORE_READONLY_PASSWORD=datastore" >> .env

echo "HOST_FQN=$1" >> .env

docker-compose up --no-start --build

docker-compose start postgresql
docker-compose start mongo
docker-compose start redis
docker-compose start solr
docker-compose start orion
docker-compose start comet
docker-compose start nifi
docker-compose start datapusher
docker-compose start ckan

echo "Running CKAN Check..."

LOGS="$(docker-compose logs -f ckan)"
echo "$LOGS"
until echo "$LOGS" | grep "SUCCESS"; do
        >&2 echo "CKAN is unavailable - sleeping"
        if [echo "$LOGS" | grep "failed"]
        then
            docker-compose restart ckan
        fi
        LOGS="$(docker logs -f --since 10s ckan)"
        echo "$LOGS"
done

docker-compose restart ckan

cd ..
