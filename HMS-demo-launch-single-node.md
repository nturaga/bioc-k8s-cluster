
## Launch a large machine

- `e2-medium` is regular machine type 2 vCPUS and 8GB ram

- `e2-standard-8` is 8 CPUs and 32GB of ram

		gcloud container clusters create my-gke-cluster --disk-size=100 --num-nodes=1 --machine-type=e2-standard-8 --zone us-east1-b


		gcloud container clusters get-credentials my-gke-cluster --zone us-east1-b
		
		
		helm install mybioc \
			--repo https://github.com/Bioconductor/helm-charts/raw/devel bioconductor \
			-f https://raw.githubusercontent.com/Bioconductor/bioconductor-helm/devel/examples/gke-vals.yaml \
			--set image.repository=bioconductor/bioconductor_docker \
			--set image.tag=RELEASE_3_14

		helm delete mybioc
		
		gcloud container clusters delete my-gke-cluster --zone us-east1-b 
