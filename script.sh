#!/bin/bash

repoUrl="$1"
fqdn="$2"
redis="$3"

echo "Installing azure city platform"
echo "  - Repo: $repoUrl"
echo "  - Host: $fqdn"
echo "  - Redis: $redis"

git clone $repoUrl azureiotcity

cd azureiotcity

./install.sh $fqdn $redis