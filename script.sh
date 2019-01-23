#!/bin/bash
echo "Give a name for the resourcegroup: "
read rgname # resource group iotcity4
dnsname=".westeurope.cloudapp.azure.com"

redis="localhost"

echo "Installing azure city platform"
echo "  - Host: $rgname$dnsname"
echo "  - Redis: $redis"

rm -R -f azureiotcity

git clone https://github.com/mathi123/azure-iot azureiotcity

cd azureiotcity

./scripts/install.sh $rgname $rgname$dnsname $redis