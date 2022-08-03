#!/bin/bash
#$ -l h_rt=96:00:00
#$ -l mem=16G
#$ -l rmem=16G
#$ -P alloteropsis
#$ -q alloteropsis.q
#$ -pe openmp 16
#$ -v OMP_NUM_THREADS=16
#$ -j y

source /usr/local/extras/Genomics/.bashrc

perlbrew switch perl-5.26.1-thread

canu  -p TTPH -d TTPHC useGrid=false maxThreads=16 maxThreads=16 maxMemory=252\
 genomeSize=0.85g \
 -pacbio /mnt/fastdata/bo1ltd/Themeda-Isielma-genomes/raw-PacBio/TTPH_pacbio_raw.fasta
