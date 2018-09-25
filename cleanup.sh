source vars.sh

az group delete --resource-group $RES_GROUP
az ad sp delete --id http://$ACR_NAME-pull