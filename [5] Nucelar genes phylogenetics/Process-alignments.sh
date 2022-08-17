#!/bin/bash
#$ -l h_rt=336:00:00
#$ -l mem=16G
#$ -l rmem=16G
#$ -P alloteropsis
#$ -q alloteropsis.q
#$ -j y

#####################################################################################
#	Script Name: 	Process-alignments.sh
#	Description: 	clean BUSCO alingments
#	Author:		LTDunning
#	Last updated:	07/01/2021
#####################################################################################

source /usr/local/extras/Genomics/.bashrc

#### INFILES

# [1] Direcotry with raw FASTA alingments
ALN_DIR=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-alignments/ShortRead_to_alignment-ragtag.scaffold.500.organelle/final_alignments

## [2] BUSCO alingment lengths
Length=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-markers/ragtag.scaffold.500/BUSCO_lengths_accurate.txt

#### SCRIPTS

trimAL=/shared/dunning_lab/Shared/programs/trimAl/source/./trimal
fastaNamesSizes=/shared/dunning_lab/Shared/scripts/perl/fastaNamesSizes.pl

#### PARAMETERS

Minimum_sequence_length=200
Minimum_alignment_length=500
Minimum_number_of_sequences=82

### [step 1] copy alingments and replace N with -
mkdir temp1
ls ${ALN_DIR} | while read line ; do cat ${ALN_DIR}/"$line" | sed '/^>/ ! s/N/-/g' > temp1/"$line" ; done

### [step 2] remove alingments of unusual length
ls temp1 | while read line ; do perl ${fastaNamesSizes} temp1/"$line" | head -n 1 | cut -f 2 | sed 's/^/'$line'\t/g' >> lengths.txt ; done
cat lengths.txt | cut -f 1 -d '.' | while read line ; do grep "^$line\s" ${Length} >> to_compare ; done 
paste lengths.txt to_compare | awk '{$5 = $2 - $4} 1' | grep -v "\s0$" | cut -f 1 -d  ' ' > unusual_lengths.txt
cat unusual_lengths.txt | while read line ; do rm temp1/"$line" ; done
rm unusual_lengths.txt to_compare lengths.txt

### [step 3] clean the alingments with trimAL 
mkdir temp2
ls temp1 | while read line ; do ${trimAL} -in temp1/"$line" -out temp2/"$line" -automated1 ; done

### [step 4] make some tempory files without gaps so the amount of sequence info can be counted
mkdir temp3
ls temp2 | while read line ; do cat temp2/"$line" | sed '/^>/ ! s/-//g' > temp3/"$line" ; done

### [step 5] count lengths
mkdir temp4
ls temp3 | while read line ; do perl ${fastaNamesSizes} temp3/"$line" | awk -v min="$Minimum_sequence_length" '$2 >=min' | cut -f 1 > temp4/"$line" ; done

### [step 6] unwrap alingments and remove short sequences
mkdir temp5
ls temp2 | while read line ; do cat temp2/"$line" | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}'  > temp5/"$line" ; done
ls temp4 | while read line ; do cat temp4/"$line" | while read line2 ; do sed '/'$line2'/,+1 d' -i temp5/"$line" ; done ; done

### [step 7] remove short alignments
sed '/^$/d' -i temp5/*
ls temp5 | while read line ; do cat temp5/"$line" |  head -n 2 | tail -1 | awk '{ print length }' | sed 's/^/'$line'\t/g' | awk -v min="$Minimum_alignment_length" '$2 <min' | cut -f 1 >> GOOD ; done 
cat TOO_SHORT | while read line ; do rm temp5/"$line" ; done

### [step 8] create new direcoty of final alingments with the right number of taxa in
mkdir Final_alignments
grep -c ">" temp5/* | sed 's/:/\t/g' | awk -v min="$Minimum_number_of_sequences" '$2 >=min' | cut -f 1 | while read line ; do cp "$line" Final_alignments ; done

### [step 9] clean names
cd Final_alignments/
ls | while read line ; do cat "$line" | cut -f 1 -d ' ' | cut -f 1 | sed 's/.vertical//g'  > "$line".1 ; done
rm *a
ls | cut -f 1,2 -d '.' | while read line ; do mv "$line".1 "$line" ; done


cd ../






