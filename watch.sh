source vars.sh

az acr task create \
    --registry $ACR_NAME \
    --name tasksimpleweb \
    --image simpleweb:{{.Run.ID}} \
    --arg REGISTRY_NAME=$ACR_NAME.azurecr.io \
    --context https://github.com/$GIT_USER/acrtasks.git \
    --file Dockerfile-app \
    --branch master \
    --git-access-token $GIT_PAT