# README - Azure Bioconductor Cluster with NFS volume mount

## Start Kubernetes cluster on AKS

Login to AKS

	az login

Start a kubernetes cluster on AKS

	az aks create -g bioconductor \
		-n biock8scluster \
		--enable-cluster-autoscaler \
		--min-count 1 \
		--node-count 25 \
		--max-count 50 \
		--output table

Get cluster credentials

	az aks get-credentials -g bioconductor --name biock8scluster


## INSTALL helm chart

Clone and install the helm chart to get going with the Bioc RedisParam on K8s.

Clone the repo

    git clone https://github.com/nturaga/bioc-k8s-cluster/

Install the helm chart

	helm install biock8scluster \
		--set workerPoolSize=100  \
		--set biocVersion='3.13' \
		--set workerImageTag='RELEASE_3_13' \
			aks-helm-chart --wait

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
## Azure BLOB store set up

If you want to save files to long term storage, you want to use Azure Blob store (which is similar to a Google Bucket or AWS s3).

You first have to generate a SAS (Shared Access Signature) for the blob store.

### Az sas token

	kubectl create secret generic blob-sas-key
		--from-file=service_account_key=azure-sas.tok
