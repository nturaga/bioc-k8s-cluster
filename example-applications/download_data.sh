#!/bin/bash

DIR=`pwd`
SRA=ftp://ftp.sra.ebi.ac.uk/vol1/fastq

for i in `seq 28 40`; 
do 
  mkdir -p ${DIR}/data/DRR0161${i}; 
  cd ${DIR}/data/DRR0161${i}; 
  wget -bqc ${SRA}/DRR016/DRR0161${i}/DRR0161${i}_1.fastq.gz; 
  wget -bqc ${SRA}/DRR016/DRR0161${i}/DRR0161${i}_2.fastq.gz; 
done

cd $DIR
