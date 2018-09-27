#!/bin/bash
fqdn="$1"
redis="$2"

echo "Installing azure city platform"
echo "  - Host: $fqdn"
echo "  - Redis: $redis"

./scripts/install-dependencies.sh

./scripts/start-docker.sh $fqdn

./scripts/enable-datapusher.sh

python ./scripts/configure-ckan.py
