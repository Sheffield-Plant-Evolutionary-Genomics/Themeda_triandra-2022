#!/bin/bash
#$ -l h_rt=24:00:00
#$ -l rmem=8G
#$ -j y

source /usr/local/extras/Genomics/.bashrc
alias python=python3

i=$(expr $SGE_TASK_ID)

assemblies=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/ID-cp/ragtag.scaffold.500.fasta
lineages=/shared/dunning_lab/Shared/programs/BUSCO-db/poales_odb10
tempfiles=/mnt/fastdata/bo1ltd/AUS1-BUSCO/temp

cp -r /usr/local/extras/Genomics/apps/augustus/current/config .

export AUGUSTUS_CONFIG_PATH=/mnt/fastdata/bo1ltd/AUS1-BUSCO/config

# busco version: BUSCO 3.1.0

busco --in ${assemblies} --lineage_path ${lineages}/ --out ragtag.scaffold.500 --mode geno --tmp_path ${tempfiles}/ --tarzip 




