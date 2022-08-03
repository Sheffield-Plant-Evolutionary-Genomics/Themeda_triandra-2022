#!/bin/bash
#$ -l h_rt=96:00:00
#$ -t 1-2
#$ -l mem=16G
#$ -l rmem=16G
#$ -j y

#####################################################################################
#	Script Name: 	sms_trees_array.sh
#	Description: 	use SMS to generate ML trees with best model and bootstrap reps for 100s of alignments
#	Author:		LTDunning
#	Last updated:	07/01/2021
#####################################################################################

source /usr/local/extras/Genomics/.bashrc

i=$(expr $SGE_TASK_ID)

#### INFILES

files=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/cpTree/files

sms=/shared/dunning_lab/Shared/programs/sms-1.8.1/./sms.sh



#### Step 1: create directories and convert fasta to phylip

head -$i ${files} | tail -1 | while read line ; do mkdir tree_"$line" ; cd tree_"$line" ; cp  ../"$line" . ; done


#### Step 2: run sms and make a copy of the tree

head -$i ${files} | tail -1 | while read line ; do cd tree_"$line" ; ${sms} -i $line -d nt -t -b 100 ; done









