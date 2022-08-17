#!/bin/bash
#$ -l h_rt=96:00:00
#$ -l mem=48G
#$ -l rmem=48G
#$ -j y
#$ -t 1-10


source /usr/local/extras/Genomics/.bashrc
module load apps/python/anaconda3-4.2.0

i=$(expr $SGE_TASK_ID)
list_mpileup=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/hmmploidy/CHRs
mpileup_dir=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/mpileup/ragtag.scaffold.500.org-no-Het/split_mpiles
genome=NO-HET-ragtag.scaffold.500.org
window=100000

head -$i ${list_mpileup} | tail -1 | while read line ; do mkdir -p ${genome}_w${window}/Individual/"$line" ; cd ${genome}_w${window}/Individual/"$line" ; cp ${mpileup_dir}/"$line" "$line".mpileup ; echo "$line".mpileup > FILES ; done

head -$i ${list_mpileup} | tail -1 | while read line ; do cd ${genome}_w${window}/Individual/"$line" ; python /shared/dunning_lab/Shared/programs/HMMploidy-master/./Genotype_Likelihoods.py FILES ; done

head -$i ${list_mpileup} | tail -1 | while read line ; do cd ${genome}_w${window}/Individual/"$line" ; gunzip *gz ; Rscript /shared/dunning_lab/Shared/programs/HMMploidy-master/HMMploidy.R file="$line"  maxPloidy=6  wind=${window}  minInd=2 ; done

head -$i ${list_mpileup} | tail -1 | while read line ; do mkdir ${genome}_w${window}/combined ; cp ${genome}_w${window}/Individual/"$line"/"$line".HMMploidy  ${genome}_w${window}/combined ; done


