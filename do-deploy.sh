az group create -l westus -n prometheus-rg
az group deployment create -g prometheus-rg --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
