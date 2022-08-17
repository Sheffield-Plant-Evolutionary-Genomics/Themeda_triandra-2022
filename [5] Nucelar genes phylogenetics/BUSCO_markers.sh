#!/bin/bash


## infiles from BUSCO program

BUSCO_summary=/mnt/fastdata/bo1ltd/BUSCO/run_ragtag.scaffold.500.organelle/full_table_ragtag.scaffold.500.organelle.tsv
BUSCO_predicted_genes=/mnt/fastdata/bo1ltd/BUSCO/run_ragtag.scaffold.500.organelle/augustus_output/predicted_genes.tar.gz


## copy files and generate list of the complete BUSCO and extract annotation info for these and combine into a single file

cat ${BUSCO_summary} | grep "Complete" > complete_busco
cp ${BUSCO_predicted_genes} .
tar -xzvf predicted_genes.tar.gz
sed -i '/^#/d' predicted_genes/*
ls predicted_genes | while read line ; do cat predicted_genes/"$line" | sed 's/^/'$line'\t/g' >> combined_predicted_genes ; done


## each BUSCO potentially has multiple annotations, to ensure we extract the right annotation we make sure it matches with the cooridnates from the ${BUSCO_summary}, and then we extract the CDS annotations for gene

cat complete_busco  | while read line ; do GENE=$(echo "$line" | cut -f 1 ); SCAF=$(echo "$line" | cut -f 3 ) ; START=$(echo "$line" | cut -f 4)  ; STOP=$(echo "$line" | cut -f 5);  grep -E "^$GENE" combined_predicted_genes | grep "\stranscript\s" | grep "$SCAF" | awk -v min="$START" '$5==min' | awk -v min="$STOP" '$6==min' | head -n 1 >> intermediate ; done
cat intermediate |  while read line ; do GENE=$(echo "$line" | cut -f 1 -d '.' ); FILE=$(echo "$line" | cut -f 1 ) ; trans=$(echo "$line" | cut -f 10) ; grep "^$FILE" combined_predicted_genes | grep "\sCDS\s" | grep "$trans" | cut -f 2,5,6 | sed 's/^/'$GENE'\t/g' >> intermediate2 ; done


## make CDS bed file

cat intermediate2 | cut -f 2,3,4 > CDS.bed


## make CDS_to_gene file [basically gives the coordinates

cat intermediate2 |  awk '!seen[$1]++' | cut -f 1 | while read line ; do grep "^$line\s" intermediate2 | sort -k3n >> intermediate3 ; done
cat intermediate3 |  awk '!seen[$1]++' | cut -f 1,2,3 > intermediate4
cat intermediate2 |  awk '!seen[$1]++' | cut -f 1 | while read line ; do grep "^$line\s" intermediate2 | tail -1  | cut -f 4 >> intermediate5 ; done
paste intermediate4 intermediate5 > CDS_to_gene.txt


## list orientation of BUSCO genes

cat intermediate  | grep "+" | cut -f 1 -d '.'  > BUSCO_forward
cat intermediate  | grep "\s-\s" | cut -f 1 -d '.'  > BUSCO_reverse


## lengths of BUSCO genes 

cat intermediate3 |   awk '!seen[$1]++' | cut -f 1 | while read line ; do grep "^$line\s" intermediate3 | awk '{$5 = $4 - $3} 1' | cut -f 5 -d ' ' | awk -F',' '{sum+=$1;} END{print sum;}' | sed 's/^/'$line'\t/g' >> BUSCO_lengths ; done

## number of Introns for each BUSCO genes

cat intermediate3 |   awk '!seen[$1]++' | cut -f 1 | while read line ; do grep "^$line\s" intermediate3 | wc -l | awk '{$2 = $1 - 1} 1' | cut -f 2 -d ' ' | sed 's/^/'$line'\t/g' >> BUSCO_introns ; done

## lengths of BUSCO including exon counts [to mitigate effect of 0/1 encoding]  

paste BUSCO_introns BUSCO_lengths | awk '{$5 = $2 + $4} 1' | cut -f 1,5 -d ' ' | sed 's/ /\t/g' > BUSCO_lengths_accurate.txt

## tidy up

rm -r predicted_genes* intermediate* combined_predicted_genes





