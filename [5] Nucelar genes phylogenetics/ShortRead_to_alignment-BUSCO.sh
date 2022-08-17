#!/bin/bash
#$ -l h_rt=336:00:00
#$ -l mem=16G
#$ -l rmem=16G
#$ -P alloteropsis
#$ -q alloteropsis.q
#$ -j y

#####################################################################################
#	Script Name: 	ShortRead_to_alignment.sh
#	Description: 	This scirpt maps short-read data to a reference and generates a consensus sequence
#	Author:		LTDunning, JKOlofsson & DWood
#	Last updated:	07/01/2021
#####################################################################################

source /usr/local/extras/Genomics/.bashrc

#### INFILES

# [1] File with each line listing path_to_bam_direcotry<\t>bam_file<\t>sample_name<\t>poistion_depth_filter<\t>basecall_depth_filter
SAMPLES=/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-alignments/Themeda_sample_BUSCO

# [2] CDS.bed and CDS_to_gene.txt (see "CDS_gff_to_bed.sh")
BED=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-markers/ragtag.scaffold.500/CDS.bed
GENES=//mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/BUSCO-markers/ragtag.scaffold.500/CDS_to_gene.txt

# [3] reference fasta file used for generating the bam files
REF=/mnt/fastdata/bo1ltd/Themeda-v2-MolEcol/ID-cp/ragtag.scaffold.500.organelle.fasta

#### SCRIPTS

countBases2=/shared/dunning_lab/Shared/scripts/python/countBases2.py
Remove_N_OnlySeqs=/shared/dunning_lab/Shared/scripts/python/Remove_N_OnlySeqs.py
split_annotated_seq=/shared/dunning_lab/Shared/scripts/perl/split_annotated_seq.pl

#### PARAMETERS

mapping_quality=20



mkdir ShortRead_to_alignment-BUSCO
cd ShortRead_to_alignment-BUSCO

#### Step 1: Reformat BED file so that every position is called

perl ${split_annotated_seq}  ${BED} 
awk '{OFS="\t"; if (!/^#/){print $1,$2-1,$2,$4"/"$5,"+"}}' Step_1.txt > Step_2.txt
rm Step_1.txt


#### Step 2: Call SNPs and generate mpileup file

cat ${SAMPLES} | while read line ; do path=$(echo "$line" | cut -f 1); bam=$(echo "$line" | cut -f 2) ; ID=$(echo "$line" | cut -f 3) \
    ; samtools mpileup -q ${mapping_quality} -A -l Step_2.txt -f ${REF} ${path}/${bam}  >  ${ID}.mpileup ; done

#### Step 3: Read depth filter 

cat ${SAMPLES} | while read line ; do depth=$(echo "$line" | cut -f 4); ID=$(echo "$line" | cut -f 3) ; \
    awk -v depth="$depth" '(NR>1) && ($4 >= depth) ' ${ID}.mpileup > ${ID}.mpileup.mod ; done

ls *.mod | sed 's/.mod//g' | while read line ; do mv "$line".mod "$line" ; done


#### Step 4: Maipulate mpileup file so we can run the countBases2.py script

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; awk 'BEGIN{OFS="\t"}; {print $1":"$2, $0}' ${ID}.mpileup > ${ID}.mpileup.1 ; done

awk '{print $1":"$3, $1,$3,$4,$5}' Step_2.txt | sed 's/ /\t/g'  > SNP.bed.2

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; \
    awk 'NR==FNR{a[$1]=$0 ; next}  {{ found=0; for(i=1;i<=NF;i++) { if($i in a) { print a[$i]; found=1; break; } } if (!found) {print $0} } }' \
    ${ID}.mpileup.1 SNP.bed.2  > ${ID}.mpileup.2 ; done

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; awk 'BEGIN {OFS="\t"}; { if ($5=="+" ) $5="0"; print $2,$3,$4,$5,$6,$7 }' \
    ${ID}.mpileup.2 |sed 's/ /\t/g' |   sed 's/\/\A,C,G//g' | sed 's/\/\A,G,C//g' | sed 's/\/\A,C,T//g' | sed 's/\/\A,T,C//g' | sed 's/\/\A,G,T//g' \
    | sed 's/\/\A,T,G//g' | sed 's/\/\C,A,G//g' | sed 's/\/\C,G,A//g' | sed 's/\/\C,A,T//g' | sed 's/\/\C,T,A//g' | sed 's/\/\C,G,T//g' | sed 's/\/\C,T,G//g' \
    | sed 's/\/\G,A,C//g' | sed 's/\/\G,C,A//g' | sed 's/\/\G,A,T//g' | sed 's/\/\G,T,A//g' | sed 's/\/\G,C,T//g' | sed 's/\/\G,T,C//g' | sed 's/\/\T,A,C//g' \
    | sed 's/\/\T,C,A//g' | sed 's/\/\T,A,G//g' | sed 's/\/\T,G,A//g' | sed 's/\/\T,C,G//g' | sed 's/\/\T,G,C//g' | sed 's/\/\A,C//g' | sed 's/\/\C,A//g'     \
    | sed 's/\/\A,G//g' | sed 's/\/\G,A//g' | sed 's/\/\A,T//g' | sed 's/\/\T,A//g' | sed 's/\/\C,G//g' | sed 's/\/\G,C//g' | sed 's/\/\C,T//g' | sed 's/\/\T,C//g' \
    | sed 's/\/\G,T//g' | sed 's/\/\T,G//g'  | sed 's/\/\A//g'  | sed 's/\/\C//g' | sed 's/\/\G//g' | sed 's/\/\T//g' > ${ID}.mpileup.3 ; done

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; awk '{gsub("/","A",$3)}1' ${ID}.mpileup.3 |  awk '{gsub("+","0",$4)}1' \
    |  awk '{gsub("N","A",$3)}1' | sed 's/ /\t/g'   > ${ID}.mpileup.4 ; done

#### Step 5: Run the countBases2.py script, then remove mpileup files

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; python2 ${countBases2} ${ID}.mpileup.4 > ${ID}.count ; done
rm *mpileup.[0-9]

#### Step 6: Base depth filter 

cat ${SAMPLES} | while read line ; do depth2=$(echo "$line" | cut -f 5); ID=$(echo "$line" | cut -f 3) ; cat ${ID}.count \
    | awk -v depth="$depth2" 'BEGIN { OFS="\t" ; } ; { if ($5 < depth) $5 = "0" ; else $5 = $5; } ; 1' \
    | awk -v depth="$depth2" 'BEGIN { OFS="\t" ; } ; { if ($6 < depth) $6 = "0" ; else $6 = $6; } ; 1' \
    | awk -v depth="$depth2" 'BEGIN { OFS="\t" ; } ; { if ($7 < depth) $7 = "0" ; else $7 = $7; } ; 1' \
    | awk -v depth="$depth2" 'BEGIN { OFS="\t" ; } ; { if ($8 < depth) $8 = "0" ; else $8 = $8; } ; 1' > ${ID}.count.mod ; done

ls *.mod | sed 's/.mod//g' | while read line ; do mv "$line".mod "$line" ; done

#### Step 7: Maipulate count file so we can run generate a fasta file

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; awk -F "\t" 'BEGIN{OFS="\t"};{print $0, $5+$6+$7+$8+$9+$10}' ${ID}.count \
    | awk 'BEGIN {OFS="\t"};{max=0;for(i=5;i<9;i++)if($i!~/NA/&&$i>max){max=$i;}; maxfreq=0; if($13==0) maxfreq="-nan" ; else maxfreq=max/$13 ; print $0, maxfreq}' \
    | awk 'BEGIN{OFS="\t"}; { if($14=="-nan" ) $14="0"; print $0}' | awk 'BEGIN{OFS="\t"} {j=sprintf("%8.2f", $14); print $0, j}' \
    | awk 'BEGIN{OFS="\t"}; {a=0; if($13==0) a=0 ; else a=sprintf("%8.2f",$5/$13);print $0, a}' \
    | awk 'BEGIN{OFS="\t"}; {c=0; if($13==0) c=0 ; else c=sprintf("%8.2f",$6/$13);print $0, c}' \
    | awk 'BEGIN{OFS="\t"}; {g=0; if($13==0) g=0 ; else g=sprintf("%8.2f",$7/$13);print $0, g}' \
    | awk 'BEGIN{OFS="\t"}; {t=0; if($13==0) t=0 ; else t=sprintf("%8.2f",$8/$13);print $0, t}' \
    | awk -v col=A 'BEGIN{OFS="\t"}; {NT=""; if($15==$16){NT=col}else{NT="-";}; print $0, NT}'  \
    | awk -v col=C 'BEGIN{OFS="\t"}; {NT=""; if($15==$17){NT=col}else{NT="-";}; print $0, NT}'  \
    | awk -v col=G 'BEGIN{OFS="\t"}; {NT=""; if($15==$18){NT=col}else{NT="-";}; print $0, NT}'  \
    | awk -v col=T 'BEGIN{OFS="\t"}; {NT=""; if($15==$19){NT=col}else{NT="-";}; print $0, NT}'  \
    | awk 'BEGIN{OFS="\t"}; {print $1,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $20$21$22$23}'  \
    | awk 'BEGIN {OFS="\t"};{if($15=="----")$15="N";print $0}' | awk 'BEGIN {OFS="\t"};{gsub("-","",$15); print $0}' > ${ID}.count.2 ; done

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; awk -v col5=A 'BEGIN {OFS="\t"};{GTA="";if($5!=0){GTA=col5;}else{GTA="-";}print $0,GTA}' ${ID}.count.2 \
    | awk -v col6=C 'BEGIN {OFS="\t"};{GTC="";if($6!=0){GTC=col6;}else{GTC="-";}print $0,GTC}' \
    | awk -v col7=G 'BEGIN {OFS="\t"};{GTG="";if($7!=0){GTG=col7;}else{GTG="-";}print $0,GTG}' \
    | awk -v col8=T 'BEGIN {OFS="\t"};{GTT="";if($8!=0){GTT=col8;}else{GTT="-";}print $0,GTT}' \
    | awk 'BEGIN {OFS="\t"};{print$0, $16$17$18$19}' | awk 'BEGIN {OFS="\t"};{if($20=="----")$20="N";print $0}' \
    | awk 'BEGIN {OFS="\t"};{gsub("-","",$20); print $0}' | awk 'BEGIN{OFS="\t"}; {print $1,$2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $20}' \
    | awk 'BEGIN {OFS="\t"}; {if($14>0.9 && length($16)>=2) $16=$15; print $0}' | awk 'BEGIN {OFS="\t"}; {if($4>100000000000)$16="N"; print $0}' \
    | awk 'BEGIN {OFS="\t"};{ if(length($16)>=3)$16="N";print$0 }' > ${ID}.count.3 ; done 

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; awk -v ID="$ID" 'BEGIN{OFS="\t"}; {print ID, $1":"$2, $16}' ${ID}.count.3 > ${ID}.count.4 ; done

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ;  awk 'BEGIN{OFS="\t"}; {GT2==""; if($3=="A"){GT2="AA";}else{GT2="-"} print $0, GT2}' ${ID}.count.4 \
    | awk 'BEGIN{OFS="\t"}; {if($3=="C"){$4="CC";} print $0}' | awk 'BEGIN{OFS="\t"}; {if($3=="G"){$4="GG";} print $0}' \
    | awk 'BEGIN{OFS="\t"}; {if($3=="T"){$4="TT";} print $0}' | awk 'BEGIN{OFS="\t"}; {if($3=="AC"){$4=$3;} print $0}'  \
    | awk 'BEGIN{OFS="\t"}; {if($3=="AG"){$4=$3;} print $0}' | awk 'BEGIN{OFS="\t"}; {if($3=="AT"){$4=$3;} print $0}'   \
    | awk 'BEGIN{OFS="\t"}; {if($3=="CG"){$4=$3;} print $0}' | awk 'BEGIN{OFS="\t"}; {if($3=="CT"){$4=$3;} print $0}'   \
    | awk 'BEGIN{OFS="\t"}; {if($3=="GT"){$4=$3;} print $0}' | awk 'BEGIN{OFS="\t"}; {if($3=="N"){$4="NA";} print $1, $2, $4}' > ${ID}.count.5 ; done

#### Step 8: Make a 'vertical fasta' which the sequences can then be extracted from, then remove multiple count files 

cat ${SAMPLES} | while read line ; do ID=$(echo "$line" | cut -f 3) ; cat ${ID}.count.5  | sed 's/"//g' | sed 's/NA/N/g' \
    | sed 's/AC/M/g' | sed 's/AG/R/g' | sed 's/AT/W/g' | sed 's/CG/S/g' | sed 's/CT/Y/g' | sed 's/GT/K/g' | sed 's/AA/A/g' \
    |sed 's/CC/C/g' |sed 's/GG/G/g' | sed 's/TT/T/g' | sed 's/.bam/\n/g' | sed 's/The/>The/g' > ${ID}.vertical.fasta  ; done

rm *count*


#### Step 9: Extract fasta sequences  

for filename in *.fasta; do echo "sed -n -e '/CCCC:AAA/,\$p' "$filename" | sed '/CCCC:BBB/q' | tail -n +2 | cut -f 3 | tr --delete '\n' | sed 's/^/>'$filename'\n/g' | sed 's/.fasta//g' | sed '\$a\' >> DDDD.fa" \
    > coms ; cat ${GENES} | while read line ; do var1=$(echo "$line" | cut -f 2 ); var2=$(echo "$line" | cut -f 3 ) ; var3=$(echo "$line" | cut -f 4 ); \
    var4=$(echo "$line" | cut -f 1 ); sed 's/AAA/'$var2'/g' coms | sed 's/BBB/'$var3'/g' | sed 's/CCCC/'$var1'/g' | sed 's/DDDD/'$var4'/g' >> coms.sh ; done ; done 

chmod u+x coms.sh

./coms.sh

#### Step 10: remove 'N' only sequences
for filename in *.fa ; do python ${Remove_N_OnlySeqs} "$filename" > "$filename".fa2 &&mv "$filename".fa2 "$filename"  ; done
mkdir final_alignments
mv *fa final_alignments
rm *vertical.fasta*

~

