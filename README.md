# bioc-k8s-cluster

Bioconductor Kubernetes Cluster that can be launched on demand on either AKS or GKE

## Software Requirements on local machine

1. Docker (https://docs.docker.com/get-docker/)

2. Kubernetes, specifically `kubectl` (https://kubernetes.io/docs/tasks/tools/)

3. Google Cloud SDK or Microsoft Azure CLI (depending on your cloud choice).
   1. Google Cloud SDK (https://cloud.google.com/sdk/docs/install)
   2. Microsoft Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

4. Helm (https://helm.sh/docs/intro/install/)

5. Git

## Instructions

- **GKE** launch instructions are in [gke-helm-chart](./gke-helm-chart/README.md)

- **AKS** launch instructions are in [aks-helm-chart](./aks-helm-chart/README.md)


## Maintainer

- Nitesh Turaga - nturaga.bioc at gmail dot com
