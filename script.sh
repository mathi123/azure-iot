#!/bin/bash

apt-get update

apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update

apt-get install -y docker-ce

curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

git clone https://github.com/mathi123/azure-iot.git

cd azure-iot

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

chmod +x enable_datapusher.sh

./enable_datapusher.sh

sleep 15

python Init_ckan_for_nifi.py
