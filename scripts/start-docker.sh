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

echo "Running Ckan Check..."

while [[ $DONE != *"DB: SUCCESS"*  ]]
do
        echo "Ckan not up, restarting"
        sleep 3
        DONE="$(docker-compose logs ckan)"
        docker-compose restart ckan
        docker ps | grep ckan
done

echo "Ckan Up"

cd ..
