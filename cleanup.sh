source vars.sh

az container delete --yes --name acr-tasks --resource-group $ACR_NAME
az acr task delete --name tasksimpleweb --registry $ACR_NAME
az group delete --yes --resource-group $RES_GROUP
az ad sp delete --id http://$ACR_NAME-pull