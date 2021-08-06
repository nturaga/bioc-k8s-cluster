README
===========

## Getting started with a Bioconductor Kubernetes Cluster

Clone and install the helm chart to get going with K8s managed on-demand the Bioc Cluster.

### Software Requirements on local machine

1. Docker (https://docs.docker.com/get-docker/)

2. Kubernetes, specifically `kubectl` (https://kubernetes.io/docs/tasks/tools/)

3. Google Cloud SDK or Microsoft Azure CLI (depending on your cloud choice). 
   1. Google Cloud SDK (https://cloud.google.com/sdk/docs/install)
   2. Microsoft Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

4. Helm (https://helm.sh/docs/intro/install/)

5. Git

### NOTE: You need to have a Google cloud or Microsoft azure account. More likely than not, this will need a credit card.


### Quickstart

1. Log in to Gcloud

        gcloud auth login

1. Clone the repo on your local machine.

        git clone https://github.com/nturaga/bioc-k8s-cluster.git

1. Change into the cloned repository,

        cd bioc-k8s-cluster

1. You have chosen the Google Kubernetes Engine as your managed production ready cluster environment. 
   
   1. Launch a GKE cluster, this assumes you have a Google cloud account. Let's start with 10 nodes on machine type 'e2-standard-4'

            GKE_CLUSTER=bioccluster; GKE_ZONE=us-east1-b

            gcloud container clusters create \
                --zone "$GKE_ZONE" \
                --num-nodes 3 \
                --machine-type=e2-standard-4 "$GKE_CLUSTER"

            gcloud container clusters get-credentials "$GKE_CLUSTER" --zone "$GKE_ZONE"

   2. Install the helm chart

            helm install "$GKE_CLUSTER" \
                --set workerPoolSize=10 \
                --set biocVersion='3.14' \
                --set workerImageTag='RELEASE_3_14' gke-helm-chart --wait

2. Login to manager node

        kubectl exec -it pod/manager -- /bin/bash

        /host/ is NFS volume

1. Deploy some work in R

        library(RedisParam)

        p <- RedisParam(workers = 10, 
                        jobname = "demo", 
                        is.worker = FALSE)

        fun <- function(i) {
            Sys.sleep(1)
            Sys.info()[["nodename"]]
        }

        ## 100 seconds / 50 workers
        system.time({
            res <- bplapply(1:13, fun, BPPARAM = p)
        })

        ## each worker slept 2 or 3 times
        table(unlist(res))


1. Another example, calculating the value of pi ()

        piApprox <- function(n) {
                nums <- matrix(runif(2 * n), ncol = 2)
                d <- sqrt(nums[, 1]^2 + nums[, 2]^2)
                4 * mean(d <= 1)
        }

        piApprox(1000)

        param <- RedisParam(workers = 10,  jobname = "demo", is.worker = FALSE)
        result <- bplapply(rep(10e5, 10), piApprox, BPPARAM=param)
        mean(unlist(result))

2. Stop the chart

        helm delete "$GKE_CLUSTER"

3. Delete cluster

        gcloud container clusters delete "$GKE_CLUSTER" --zone "$GKE_ZONE" --quiet
