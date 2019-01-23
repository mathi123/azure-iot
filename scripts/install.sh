#!/bin/bash
rgname="$1"

fqdn="$2"

redis="$3"

ckanuser="$4"

ckanemail="$5"

ckanpassword="$6"

ckanport="$7"


echo "Installing azure city platform" 
echo "  - Host: $fqdn"
echo "  - Redis: $redis"
echo "  - CKAN: $fqdn$ckanport"

./scripts/install-dependencies.sh

./scripts/start-docker.sh $fqdn$ckanport

./scripts/enable-datapusher.sh

./scripts/configure-ckan.sh $rgname $ckanuser $ckanemail $ckanpassword

