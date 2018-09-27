#!/bin/bash

echo "Enabling datapusher"

docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -c /etc/ckan/production.ini | docker exec -i postgresql psql -U ckan

sudo sed -i 's/ckan.plugins = /ckan.plugins = datastore datapusher /g' /var/lib/docker/volumes/azure-iot_ckan_config/_data/production.ini

sudo sed -i 's/#ckan.datapusher.formats/ckan.datapusher.formats/g' /var/lib/docker/volumes/azure-iot_ckan_config/_data/production.ini

docker-compose restart ckan

echo "Done!"