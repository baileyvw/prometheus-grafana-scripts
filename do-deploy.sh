az group create -l westus -n adobe-rg543
az group deployment create -g adobe-rg543 --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
