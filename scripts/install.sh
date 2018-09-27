#!/bin/bash
fqdn="$1"
redis="$2"

echo "Installing azure city platform"
echo "  - Host: $fqdn"
echo "  - Redis: $redis"

./install-dependencies.sh

./start-docker.sh $fqdn

./enable-datapusher.sh

python ./configure-ckan.py
