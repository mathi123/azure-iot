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

echo "POSTGRES_PORT=5432" >> .env

echo "DATASTORE_READONLY_PASSWORD=datastore" >> .env

echo "HOST_FQN=$1" >> .env

docker-compose up -d

docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -c /etc/ckan/production.ini | docker exec -i postgresql psql -U ckan

sudo sed -i 's/ckan.plugins = /ckan.plugins = datastore datapusher /g' /var/lib/docker/volumes/azure-iot_ckan_config/_data/production.ini

sudo sed -i 's/#ckan.datapusher.formats/ckan.datapusher.formats/g' /var/lib/docker/volumes/azure-iot_ckan_config/_data/production.ini

docker-compose restart ckan
