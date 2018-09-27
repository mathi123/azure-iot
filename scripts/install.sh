#!/bin/bash
fqdn="$1"
redis="$2"
organization="$3"

echo "Installing azure city platform"
echo "  - Host: $fqdn"
echo "  - Redis: $redis"
echo "  - Organization: $organization"

./scripts/install-dependencies.sh

./scripts/start-docker.sh $fqdn

./scripts/enable-datapusher.sh

./scripts/configure-ckan.sh $organization
