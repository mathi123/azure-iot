import subprocess
import os
import json

cmd = "docker exec -it ckan /usr/local/bin/ckan-paster --plugin=ckan user -c /etc/ckan/production.ini add sirus email=test@localhost password=tM5c=^MP"

pipe = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout
os.environ["APIKEY"] = pipe.read().split(",")[2].split("'")[3]

os.system("docker exec -it ckan /usr/local/bin/ckan-paster --plugin=ckan sysadmin -c /etc/ckan/production.ini add sirus")

data = json.loads('{"name":"sirus"}')

os.system("curl -X POST http://azure-iot-city.westeurope.cloudapp.azure.com:8096/api/3/action/organization_create -H \"Authorization:{}\" -d '{}'".format(os.environ["APIKEY"],json.dumps(data)))
