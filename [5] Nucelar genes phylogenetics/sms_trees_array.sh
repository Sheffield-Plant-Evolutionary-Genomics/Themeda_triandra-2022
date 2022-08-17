#!/bin/bash
#$ -l h_rt=96:00:00
#$ -t 1-2096

#####################################################################################
#	Script Name: 	sms_trees_array.sh
#	Description: 	use SMS to generate ML trees with best model and bootstrap reps for 100s of alignments
#	Author:		LTDunning
#	Last updated:	07/01/2021
#####################################################################################

source /usr/local/extras/Genomics/.bashrc

i=$(expr $SGE_TASK_ID)

#### INFILES

fasta_list=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-trees/gene-trees/INFILES
fasta_dir=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-trees/Final_alignments
# 'make' from this file /shared/dunning_lab/Shared/scripts/programs/sms-1.8.1.zip
sms=/shared/dunning_lab/Shared/programs/sms-1.8.1/./sms.sh
outdir=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-trees/gene-trees

#### SCRIPTS

fasta_to_phylip=/shared/dunning_lab/Shared/scripts/perl/Fasta2Phylip.pl

#### PARAMETERS


#### Step 1: create directories and convert fasta to phylip

head -$i ${fasta_list} | tail -1 | while read line ; do mkdir -p ${outdir}/individual/"$line" ; mkdir -p ${outdir}/combined ; mkdir -p ${outdir}/logs ;  cd ${outdir}/individual/"$line" ; perl ${fasta_to_phylip} ${fasta_dir}/"$line" "$line" ; done


#### Step 2: run sms and make a copy of the tree

head -$i ${fasta_list} | tail -1 | while read line ; do cd ${outdir}/individual/"$line" ; ${sms} -i $line -d nt -t -b 100 ; cp *phyml_tree.txt ${outdir}/combined ; done











