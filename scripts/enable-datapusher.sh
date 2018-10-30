#!/bin/bash

echo "Enabling datapusher"

cd docker

docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -c /etc/ckan/production.ini | docker exec -i postgresql psql -U ckan

# sudo sed -i 's/ckan.plugins = /ckan.plugins = datastore datapusher /g' /var/lib/docker/volumes/docker_ckan_config/_data/production.ini

sudo sed -i 's/#ckan.datapusher.formats/ckan.datapusher.formats/g' /var/lib/docker/volumes/docker_ckan_config/_data/production.ini

POSTGRESQLDBLIST="$(docker exec postgresql psql -U 'ckan' -lqt | cut -d \| -f 1)"

echo "$POSTGRESQLDBLIST"

until [[ "$POSTGRESQLDBLIST" =~ "ckan" ]]; do
        >&2 echo "Postgres is unavailable - sleeping"
        sleep 3
        POSTGRESQLDBLIST="$(docker exec postgresql psql -U 'ckan' -lqt | cut -d \| -f 1)"
        echo "$POSTGRESQLDBLIST"
done

 >&2 echo "Postgres is up - setting up ckan and enabling datapusher"

docker-compose restart ckan

cd ..

echo "Done!"
