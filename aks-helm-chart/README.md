# README

## INSTALL helm chart

Clone and install the helm chart to get going with the Bioc RedisParam on K8s.

### Quickstart

Clone the repo

	git clone https://github.com/nturaga/bioc-k8s-cluster/

Install the helm chart

	az login

	helm install aks-helm-chart

	helm install biock8scluster \
		--set workerPoolSize=40  \
		--set biocVersion='3.13' \
		--set workerImageTag='RELEASE_3_13' \
			aks-helm-chart --wait

Get list of running helm charts,

	helm list biock8scluster

Get status of the installed chart

	helm status biock8scluster

Stop the chart

	helm uninstall biock8scluster

### Requirements

1. Kubernetes cluster is running, i.e (either minikube on your local
   machine or a cluster in the cloud)

   This should work

		## minikube start
		kubectl cluster-info

1. Have helm installed!!

		brew install helm

1. Azure command line client is also needed
   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

### Debug or dry run

Very useful options to check how the templates are forming,

`--dry-run` doesn't actually install the chart and run it.

	helm install --dry-run k8s-redis-bioc-example/helm-chart/

`--debug` prints out the templates with the values.yaml embedded in them

	helm install --dry-run --debug k8s-redis-bioc-example/helm-chart/

## Azure storage account set up

This step is required only 1 time when setting up the cluster.

You need set up an 'Azure Static File Share' to act as an volume mount. This documentation is taken from:
https://docs.microsoft.com/en-us/azure/aks/azure-files-volume. The reason for the file share is to act as a

```
### Change these four parameters as needed for your own environment
AKS_PERS_STORAGE_ACCOUNT_NAME=bioconductordocker
AKS_PERS_RESOURCE_GROUP=bioconductor
AKS_PERS_LOCATION=westus
AKS_PERS_SHARE_NAME=biocbinaries

### Create a resource group
az group create --name bioconductor --location eastus

### Create a storage account
az storage account create \
	-n $AKS_PERS_STORAGE_ACCOUNT_NAME \
	-g $AKS_PERS_RESOURCE_GROUP \
	-l $AKS_PERS_LOCATION \
	--sku Standard_LRS

### Export the connection string as an environment variable,
### this is used when creating the Azure file share
export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
					   -n $AKS_PERS_STORAGE_ACCOUNT_NAME \
					   -g $AKS_PERS_RESOURCE_GROUP -o tsv)

### Create the file share
az storage share create -n $AKS_PERS_SHARE_NAME \
	--connection-string $AZURE_STORAGE_CONNECTION_STRING

# Get storage account key
STORAGE_KEY=$(az storage account keys list \
	--resource-group $AKS_PERS_RESOURCE_GROUP \
	--account-name $AKS_PERS_STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

### Echo storage account name and key
echo Storage account name: $AKS_PERS_STORAGE_ACCOUNT_NAME
echo Storage account key: $STORAGE_KEY
````

Create a kubernetes storage account secret called `azure-secret` with the help of
the command below. This will be your personal storage account's 'Azure file share' secret. DO NOT upload this on github repo.

	kubectl create secret generic azure-secret \
		--from-file=azurestorageaccountname=azurestorageaccountname.txt \
		--from-file=azurestorageaccountkey=azurestorageaccountkey.txt \
		--output=yaml > aks-helm-chart/azure-secret.yaml


	kubectl create secret generic azure-secret \
		--from-literal=azurestorageaccountname=$AKS_PERS_STORAGE_ACCOUNT_NAME \
		--from-literal=azurestorageaccountkey=$STORAGE_KEY

## Azure BLOB store set up

If you want to save files to long term storage, you want to use Azure Blob store (which is similar to a Google Bucket or AWS s3).

You first have to generate a SAS (Shared Access Signature) for the blob store.

### Az sas token

	kubectl create secret generic blob-sas-key
		--from-file=service_account_key=azure-sas.tok
