#!/bin/bash

cd docker

echo "CKAN_PORT=8096" >> .env

echo "POSTGRES_PASSWORD=ckan" >> .env

echo "SYSADMIN_PASS=tM5c=^MP" >> .env

echo "POSTGRES_PORT=5432" >> .env

echo "DATASTORE_READONLY_PASSWORD=datastore" >> .env

echo "HOST_FQN=$1" >> .env

docker-compose up --no-start --build

START=$(date +%Y-%m-%dT%H:%M:%S)

docker-compose start postgresql
docker-compose start mongo
docker-compose start redis
docker-compose start solr
docker-compose start orion
docker-compose start comet
docker-compose start nifi
docker-compose start datapusher
docker-compose start ckan

echo -n "Running CKAN Check..."

docker logs -f --until 2m ckan >& CKANLOGS.log;

while true; do
        if grep -Fq "SUCCESS" CKANLOGS.log;
        then
            echo "."
            rm CKANLOGS.log
            cd ..
            exit 0
        fi

        echo -n "."
        if grep -Fq "sqlalchemy" CKANLOGS.log;
        then
            echo "Restarting ckan container..."
            docker-compose restart ckan
            START=$(date +%Y-%m-%dT%H:%M:%S)
            echo -n "Running CKAN Check..."
        else
            docker logs --since "$START" ckan >& CKANLOGS.log
            sleep 10
        fi
done
