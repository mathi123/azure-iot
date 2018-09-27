#!/bin/bash

repoUrl="$1"
fqdn="$2"
redis="$3"
organization="$4"

echo "Installing azure city platform"
echo "  - Repo: $repoUrl"
echo "  - Host: $fqdn"
echo "  - Redis: $redis"
echo "  - Organization: $organization"

rm -R -f azureiotcity

git clone $repoUrl azureiotcity

cd azureiotcity

./scripts/install.sh $fqdn $redis $organization