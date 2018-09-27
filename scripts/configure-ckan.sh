#!/bin/bash

fqdn="$1"
apiKey=`sudo docker exec -it ckan /usr/local/bin/ckan-paster --plugin=ckan user -c /etc/ckan/production.ini add sirus email=test@localhost password=tM5cMP123 | grep apikey | sed "s/'/\n/g" | sed -n '4p'`

docker exec -it ckan /usr/local/bin/ckan-paster --plugin=ckan sysadmin -c /etc/ckan/production.ini add sirus

data="{\"name\":\"sirus\"}"

curl -X POST $fqdn:8096/api/3/action/organization_create -H "Authorization: $apiKey" -d "$data"
