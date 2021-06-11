## Load BiocParallel
library(BiocParallel)
library(RedisParam)

## Initiate BatchtoolsParam with the 
param <- RedisParam(
    workers = 50,
    jobname="demo",
    is.worker=FALSE
)

## Get vector of samples
DIR <- "/host/samples"
samples <- list.files(file.path(DIR, "data"), full.names=TRUE)

## Function to quantify a simple sample
salmon_quant <- 
    function(sample)
{
    fastq1 <- file.path(sample, paste0(basename(sample), "_1.fastq.gz"))
    fastq2 <- file.path(sample, paste0(basename(sample), "_2.fastq.gz"))
    output_dir <- '/host/bpquant'
    system2("salmon",
            args = c("quant",
                     "-i", "/host/samples/athal_index",
                     "-l", "A",
                     "-1", fastq1,
                     "-2", fastq2,
                     "-p", "16",
                     "-o", output_dir)
            ) 
}

## Run bplapply with BatchtoolsParam
bplapply(samples, salmon_quant, BPPARAM = param)
