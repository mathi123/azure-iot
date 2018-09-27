#!/bin/bash

repoUrl="$1"
repoName="$2"
fqdn="$3"
redis="$4"

echo "Installing azure city platform"
echo "  - Repo: $repoUrl"
echo "  - Repo folder: $repoName"
echo "  - Host: $fqdn"
echo "  - Redis: $redis"

git clone $repoUrl

cd $repoName $repoName

./install.sh $fqdn $redis