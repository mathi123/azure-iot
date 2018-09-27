#!/bin/bash

repoUrl="$1"
fqdn="$2"
redis="$3"

echo "Installing azure city platform"
echo "  - Repo: $repoUrl"
echo "  - Host: $fqdn"
echo "  - Redis: $redis"

rm -R -f azureiotcity

git clone $repoUrl azureiotcity

cd azureiotcity

./scripts/install.sh $fqdn $redis