#!/bin/bash
echo "CKAN Credentials: "
echo "admin name: "
read ckanuser
echo "admin email: "
read ckanemail
echo "admin paassword: "
read -s ckanpassword
ckanport=":8096"

rgname="$1"

fqdn="$2"

redis="$3"

echo "Installing azure city platform" 
echo "  - Host: $fqdn"
echo "  - Redis: $redis"
echo "  - CKAN: $fqdn$ckanport"

./scripts/install-dependencies.sh

./scripts/start-docker.sh $fqdn$ckanport

./scripts/enable-datapusher.sh

./scripts/configure-ckan.sh $rgname $ckanuser $ckanemail $ckanpassword

