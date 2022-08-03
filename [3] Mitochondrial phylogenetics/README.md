
## Inferring the phylogenetic history of Themeda using whole mitochondrial genomes


We used a reference-based approach to generate consensus sequences for the mitochondrial genome. This used the mitochondrial reference genome generated in step **[1.3] Assembling the mitochondrial genome** 
<br/><br/>
**[3.1] Cleaning nuclear data**
Prior to mapping the Themeda sequencing data, the data was cleaned using Trimmomatic v.0.38 (Bolger et al., 2014) to remove adaptor contamination, low quality bases (4 bp sliding window with mean Phred score < 20) and short reads (< 50 bp). NGSQC Toolkit v. 2.3.3 (Patel & Jain, 2012) was then used to discard reads where 80% of the sequence had a Phred score < 20 or the read contained an ambiguous base. Finally, PRINSEQ v.0.20.3 (Schmieder & Edwards, 2011) was used to remove duplicated reads. 

`trimmomatic PE -threads 6 R1.fastq.gz R2.fastq.gz -baseout OUT.fastq_trimmomatic ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10:8:TRUE SLIDINGWINDOW:4:20 MINLEN:50`

`perl IlluQC_PRLL.pl -pe OUT.fastq_trimmomatic_1P OUT..fastq_trimmomatic_2P 2 A -l 80 -s 20 -c 6 `

`perl AmbiguityFiltering.pl -i OUT.fastq_trimmomatic_1P_filtered -irev OUT.fastq_trimmomatic_2P_filtered -c 0`

`prinseq-lite.pl -fastq OUT.fastq_trimmomatic_1P_filtered_trimmed -fastq2 OUT.fastq_trimmomatic_1P_filtered_trimmed -derep 1 -out_good OUT_prinseq -no_qual_header`

Example submission script = Clean_themeda.sh

Required adaptor file = TruSeq3-PE-2.fa


**References**
Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: a flexible trimmer for Illumina sequence data. Bioinformatics, 30, 2114-2120.

Patel, R. K., & Jain, M. (2012). NGS QC Toolkit: a toolkit for quality control of next generation sequencing data. PloS one, 7, e30619.

Schmieder, R., & Edwards, R. (2011). Quality control and preprocessing of metagenomic datasets. Bioinformatics, 27, 863-864.


