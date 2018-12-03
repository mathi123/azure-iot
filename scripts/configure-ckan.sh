#!/bin/bash

organization="$1"

echo "configuring CKAN"
echo "Organisation: $organization"

USERDATA="$(docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan user -c /etc/ckan/production.ini add cityadmin email=test@localhost password=tM5cMP123)"

apiKey="$( echo "$USERDATA" | cut -d$'\n' -f 3 | sed "s/'/\n/g" | sed -n '4p')"
echo "$apiKey"

docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan sysadmin -c /etc/ckan/production.ini add cityadmin

data="{\"name\":\"$organization\"}"

curl -X POST "http://localhost:8096/api/3/action/organization_create" -H "Authorization: $apiKey" -d "$data"
