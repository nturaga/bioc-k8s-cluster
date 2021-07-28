# README

## INSTALL helm chart

Clone and install the helm chart to get going with the Bioc RedisParam on K8s.

### Quickstart

Clone the repo

    git clone https://github.com/nturaga/bioc-k8s-cluster/

Install the helm chart

    helm install aks-helm-chart

Get list of running helm charts

    helm list <release name>

Get status of the installed chart

    helm status <release name>

Stop the chart

    helm delete <release name>

### Requirements

1. Kubernetes cluster is running, i.e (either minikube on your local
   machine or a cluster in the cloud)

   This should work

        ## minikube start
        kubectl cluster-info

1. Have helm installed!!

        brew install helm

### Debug or dry run

Very useful options to check how the templates are forming,

`--dry-run` doesn't actually install the chart and run it.

    helm install --dry-run k8s-redis-bioc-example/helm-chart/

`--debug` prints out the templates with the values.yaml embedded in them

    helm install --dry-run --debug k8s-redis-bioc-example/helm-chart/

kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=$AKS_PERS_STORAGE_ACCOUNT_NAME --from-literal=azurestorageaccountkey=$STORAGE_KEY

## Az file share
kubectl create secret generic azure-secret --from-file=azurestorageaccountname=secret-storage-account.txt --from-file=azurestorageaccountkey=secret-storage-account-key.txt --output=yaml

## Az sas token
kubectl create secret generic blob-sas-key --from-file=service_account_key=azure-sas.tok
