Reproducible example Bioconductor k8s cluster
==================================

This repository contains files and scripts to demonstrate
parallel evaluation of files on the Bioconductor k8s cluster

## Download data

In your current working directory, download the data from SRA.

	sh download_data.sh
	
This will create a folder called `data` with folders starting with
`DRR16`. Each folder will contain two `fastq.gz` files containing
paired end raw reads which need to be quantified.


## Make index

Download the Arabdopsis thaliana index or use the one provided.

Make the salmon index with the command

	salmon index -i athal_index -t athal.fa.gz

