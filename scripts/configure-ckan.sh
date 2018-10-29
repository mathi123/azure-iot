#!/bin/bash

organization="$1"

echo "configuring CKAN"
echo "Organisation: $organization"

userCallback="$(docker exec -T ckan /usr/local/bin/ckan-paster --plugin=ckan user -c /etc/ckan/production.ini add cityadmin email=test@localhost password=tM5cMP123 2>&1)"

echo "$userCallback"

apiKey=$( "$userCallback" | grep apikey | sed "s/'/\n/g" | sed -n '4p')

docker exec -T ckan /usr/local/bin/ckan-paster --plugin=ckan sysadmin -c /etc/ckan/production.ini add cityadmin

data="{\"name\":\"$organization\"}"

curl -X POST "http://localhost:8096/api/3/action/organization_create" -H "Authorization: $apiKey" -d "$data"
