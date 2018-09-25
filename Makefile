ACR_NAME=bkacrdemo

login:
	az acr login --name ${ACR_NAME}

base: login
	az acr build --registry ${ACR_NAME} --image golang:alpine --file Dockerfile-base.1-10-4 .

updatebase: login
	az acr build --registry ${ACR_NAME} --image golang:alpine --file Dockerfile-base.1-11 .

watch: login
	./watch.sh

showtasks: login
	az acr task list-runs --registry ${ACR_NAME} --output table
	
base1104: login
	docker build -f Dockerfile-base.1-10-4 -t ${ACR_NAME}.azurecr.io/golang:1.10.4 .
	docker push ${ACR_NAME}.azurecr.io/golang:1.10.4

base111: login
	docker build -f Dockerfile-base.1-11 -t ${ACR_NAME}.azurecr.io/golang:1.11 .
	docker push ${ACR_NAME}.azurecr.io/golang:1.11

build1104: login base1104
	docker build --build-arg REGISTRY_NAME=${ACR_NAME} -f Dockerfile-app -t ${ACR_NAME}.azurecr.io/simpleweb:1104 .
	docker push ${ACR_NAME}.azurecr.io/simpleweb:1104
	
run1104: build1104
	docker run -d -p 8080:80 ${ACR_NAME}.azurecr.io/simpleweb:1104

build111: login base111
	docker build --build-arg REGISTRY_NAME=${ACR_NAME} -f Dockerfile-app -t ${ACR_NAME}.azurecr.io/simpleweb:111 .
	docker push ${ACR_NAME}.azurecr.io/simpleweb:111

run111: build111
	docker run -d -p 8080:80 ${ACR_NAME}.azurecr.io/simpleweb:111

deploy1104: build1104
	./deploy.sh 1104

deploy111: build111
	./deploy.sh 111

