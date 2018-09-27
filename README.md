## ACR Tasks Demo

This repository contains a simple Go web server that outputs the version of Go it was built with.  The application itself is not exciting, but the output of the web page allows us to demonstrate the features of [ACR Tasks](https://cda.ms/G9).  Specifically, you can build container images in Azure -- without a local Docker installation -- AND you can set build tasks in ACR to update your container images when the base image they build `FROM` is updated.

### Setup

For this demo you'll need the `az` CLI command [installation instructions](https://cda.ms/Gc).

You'll also need `jq` installed locally.  On a Mac `brew install jq` is all it takes.

### Running

- Edit the `vars.sh` file and change the  `ACR_NAME` to a name you'd like for your registry.

Now open the `Makefile`.  The tasks are listed in the order necessary to show the ACR Build tasks working.

```bash
setup:
	./setup.sh
	./storesp.sh

login:
	az acr login --name ${ACR_NAME}

base: login
	az acr build --registry ${ACR_NAME} --file Dockerfile-base.1-10-4 .

watch: login
	./watch.sh

deploy: login
	./deploy.sh

updatebase: login
	az acr build --registry ${ACR_NAME} --image golang:alpine --file Dockerfile-base.1-11 .

showtasks: login
	az acr task list-runs --registry ${ACR_NAME} --output table
```
#### Makefile Tasks

*setup* - Creates an Azure Resource Group and ACR Registry

The setup target runs three bash scripts:
- ./setup.sh
- ./vault.sh
- ./storesp.sh

These tasks create the Azure Resource Group named in `vars.sh`, create an Azure Container Registry, create a `vault` to store secrets, and create an Azure Service Principal` that has read permissions to your registry.

*login* - Logs in to your ACR

The login target runs one command 
- az acr login --name ${ACR_NAME}

*base* - Builds the base docker image of the application using ACR resources.  You are not required to have Docker running locally to build images!

The base target runs one command
- az acr build --registry ${ACR_NAME} --image golang:alpine --file Dockerfile-base.1-10-4 .

This command forces a Docker build from a base Dockerfile that specifies Go 1.10.4 as the build environment. The resulting image is tagged as `golang:alpine` in your registry.  Future builds of our application will use this base image in the `FROM` directive of the Dockerfile.

*watch* - Adds an ACR Build Task that watches your Github repository for changes, triggering a new build when either the base image changes or the Github repository has an update to the `master` branch.

The base target runs one command
- 	az acr build --registry ${ACR_NAME} --file Dockerfile-base.1-10-4 .

This command forces a Docker build from a base Dockerfile that specifies Go 1.10.4 as the build environment.

The login target runs one command 
- az acr login --name ${ACR_NAME}


### Useful Azure Container Registry Links
[Azure Container Registry](https://cda.ms/Gb)
[ACR Tasks Overview](https://cda.ms/G9)
[Azure Container Instances](https://cda.ms/GB)