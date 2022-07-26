# Installing helm chart on a Kubernetes cluster

Start a GKE cluster

	gcloud auth login

	gcloud container clusters create my-gke-cluster \
		--zone us-east1-b \
		--disk-size=30Gi \
		--num-nodes=2 \
		--machine-type=e2-medium

	gcloud compute disks create "mygke-nfs-pd" --size 100Gi --zone us-east1-b

	gcloud container clusters get-credentials my-gke-cluster --zone us-east1-b

	helm install myredisdemo \
		--set workers.poolSize=3 \
		--set biocVersion="3.14" \
		--set workers.image.tag="RELEASE_3_15" \
		--set persistence.size=100Gi \
		--set persistence.gcpPdName="mygke-nfs-pd" \
		--set manager.defaultCommand="/init" \
		--set rstudio.type=LoadBalancer \
		gke-helm-chart-demo --wait

Get RStudio IP address

	 echo http://$(kubectl get svc myredisdemo-rstudio --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"):8787


## Demo of a parallel compute job

Just a simple function that will sleep for a second. 

```
library(RedisParam)

Sys.setenv(REDIS_HOST = Sys.getenv("REDIS_SERVICE_HOST"))
Sys.setenv(REDIS_PORT = Sys.getenv("REDIS_SERVICE_PORT"))

p <- RedisParam(workers = 3, jobname = "binarybuild", is.worker = FALSE)

fun <- function(i) {
    Sys.sleep(1)
    Sys.info()[["nodename"]]
}

## 13 seconds / 3 workers = (5 seconds, 5 seconds, 3 seconds)
system.time({
    res <- bplapply(1:13, fun, BPPARAM = p)
})

## each worker slept 5 or 3 times
table(unlist(res))
```


## Delete everything

	helm delete myredisdemo

	gcloud compute disks delete --zone us-east1-b mygke-nfs-pd

	gcloud container clusters delete my-gke-cluster --zone us-east1-b --quiet
