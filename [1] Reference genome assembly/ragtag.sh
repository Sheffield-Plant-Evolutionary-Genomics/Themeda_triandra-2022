#!/bin/bash
#$ -l h_rt=96:00:00
#$ -l mem=16G
#$ -l rmem=16G
#$ -j y

source /usr/local/extras/Genomics/.bashrc

ragtag_scaffold.py -o TTPH-SCAF-Sorghum-Chr-organelleMasked -u /mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/RagTag/chr_Sorghum.fasta /mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/ID-cp/Themeda_triandra_TTPH-organelle-masked.fasta
