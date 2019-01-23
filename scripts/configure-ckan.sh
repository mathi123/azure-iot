#!/bin/bash

organization="$1"
#email="test@localhost"
#password="tM5cMP123"
#user="cityadmin"
user="$2"
email="$3"
password="$4"

echo "configuring CKAN"
echo "Organisation: $organization"

USERDATA=$(sudo docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan user -c /etc/ckan/production.ini add $user email=$email password=$password)

apiKey=$( echo "$USERDATA" | cut -d$'\n' -f 4 | sed "s/'/\n/g" | sed -n '4p')
echo "$apiKey"

docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan sysadmin -c /etc/ckan/production.ini add $user

data="{\"name\":\"$organization\"}"

curl -X POST "http://localhost:8096/api/3/action/organization_create" -H "Authorization: $apiKey" -d "$data"
