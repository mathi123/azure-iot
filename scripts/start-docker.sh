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

echo -n "Running CKAN Check..."

docker logs ckan >& CKANLOGS.log
if ! grep -q '[^[:space:]]' CKANLOGS.log;
then
   docker logs -f  ckan >& CKANLOGS.log;
fi

until grep -Fq "SUCCESS" CKANLOGS.log; do
        echo -n "."
        if grep -Fq "could not connect" CKANLOGS.log;
        then
            echo "Restarting ckan container..."
            docker restart ckan
            docker logs --since 30s ckan >& CKANLOGS.log
            echo -n "Running CKAN Check..."
        else
            docker logs --since 15s ckan >& CKANLOGS.log
            sleep 10
        fi
done

rm CKANLOGS.log

cd ..
