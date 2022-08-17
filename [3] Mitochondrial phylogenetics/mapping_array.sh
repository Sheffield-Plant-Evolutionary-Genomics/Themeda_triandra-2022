#!/bin/bash
#$ -l h_rt=24:00:00
#$ -j y
#$ -t 1-67
#$ -pe openmp 2
#$ -v OMP_NUM_THREADS=2

source /usr/local/extras/Genomics/.bashrc

i=$(expr $SGE_TASK_ID)

reference1=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/ID-cp/ragtag.scaffold.500.organelle.fasta
out_reference1=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/Mapping/RAGTAG-500
data=/shared/dunning_lab/Shared/Themeda_Jobson/raw
samples=/shared/dunning_lab/User/bo1ltd-backups/Themeda-Jobson/scripts/sample_list

head -$i ${samples} | tail -1 | while read line ; do bowtie2 -x ${reference1} -1 ${data}/"$line"_R1.fastq.gz -2 ${data}/"$line"_R2.fastq.gz --no-unal -p 2 | samtools view -bS - > ${out_reference1}/"$line".bam ; done
head -$i ${samples} | tail -1 | while read line ; do samtools sort ${out_reference1}/"$line".bam -o ${out_reference1}/"$line"_SORTED.bam ; done


~



