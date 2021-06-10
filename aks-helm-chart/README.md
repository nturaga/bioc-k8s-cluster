# README

## INSTALL helm chart

Clone and install the helm chart to get going with the Bioc RedisParam on K8s.

### Quickstart

Clone the repo

    git clone https://github.com/mtmorgan/k8s-redis-bioc-example.git

Install the helm chart

    helm install k8s-redis-bioc-example/helm-chart/

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

### User Settings

The defined user settings in the values.yaml file of the helm chart,
can be changed in two ways,

1. In the values.yaml file directly, where you can modify the Rstudio
   login password ``rstudioPassword`` and the number of workers you
   want to deploy `workerPoolSize`

        workerPoolSize: 5             # Number of workers in the cluster
        ...
        rstudioPassword: bioc         # RStudio password on manager

1. The other way is while deploying the helm chart,

        helm install k8s-redis-bioc-example/helm-chart/ \
            --set rstudioPassword=biocuser,workerPoolSize=10
