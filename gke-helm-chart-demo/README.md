# README

## Quickstart - Installing helm chart on a Kubernetes cluster

1. Get a Google Cloud account with the right permissions, and login.

		gcloud auth login

2. Start a GKE (Google Kubernetes Engine) cluster. The command below
   starts a 2 node cluster (machine type = `e2-medium`), the disk size
   on each node is 30 Gi.
   
   [Link for more machine types on GKE](https://cloud.google.com/blog/products/compute/google-compute-engine-gets-new-e2-vm-machine-types)

		gcloud container clusters create my-gke-cluster \
			--zone us-east1-b \
			--disk-size=30Gi \
			--num-nodes=2 \
			--machine-type=e2-medium
		
3. Create a persistent disk of size 100Gi to store your data

		gcloud compute disks create "mygke-nfs-pd" --size 100Gi --zone us-east1-b

4. Get the credentials of your cluster locally 

		gcloud container clusters get-credentials my-gke-cluster --zone us-east1-b

5. Install the Bioconductor Redis GKE helm chart, to launch the
   Bioconductor parallel computing cluster
   
   The number of workers in this cluster are `3`. At the moment the
   only versions of Bioconductor available for parallel computation
   are 3.13, 3.14 and 3.15.

		helm install myredisdemo \
			--set workers.poolSize=3 \
			--set biocVersion="3.14" \
			--set workers.image.tag="RELEASE_3_14" \
			--set persistence.size=100Gi \
			--set persistence.gcpPdName="mygke-nfs-pd" \
			--set manager.defaultCommand="/init" \
			--set rstudio.type=LoadBalancer \
			gke-helm-chart-demo --wait

		## Get list of running helm charts

		helm list
		
		## Get status of installation
		
		helm status myredisdemo
		

6. Get the RStudio IP address by visiting the 

		echo http://$(kubectl get svc myredisdemo-rstudio --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"):8787

## Clean up your cloud resources - Delete everything


1. To delete the current RedisParam cluster 

		helm delete myredisdemo
	
1. Delete persistent disk - this step only if you do not want to retain anything from the persistent disk
 
		gcloud compute disks delete --zone us-east1-b mygke-nfs-pd

1. Delete the Kubernetes cluster on GKE

		gcloud container clusters delete my-gke-cluster --zone us-east1-b --quiet

## Requirements

1. helm installed (https://helm.sh/)

        brew install helm

1. Google Cloud SDK is installed

1. Install kubernetes -
   https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/

## Debug or dry run

Very useful options to check how the templates are forming,

`--dry-run` doesn't actually install the chart and run it.

    helm install --dry-run gke-helm-chart-demo/

`--debug` prints out the templates with the values.yaml embedded in them

    helm install --dry-run --debug gke-helm-chart-demo/

