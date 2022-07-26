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



## Delete everything

	helm delete myredisdemo

	gcloud compute disks delete --zone us-east1-b mygke-nfs-pd

	gcloud container clusters delete my-gke-cluster --zone us-east1-b --quiet
