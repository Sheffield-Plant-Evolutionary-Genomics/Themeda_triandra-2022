#!/bin/bash
#$ -l h_rt=96:00:00
#$ -l mem=24G
#$ -l rmem=24G
#$ -j y






perl /shared/dunning_lab/Shared/programs/NOVOPlasty-master/./NOVOPlasty4.3.1.pl -c config.txt

~



