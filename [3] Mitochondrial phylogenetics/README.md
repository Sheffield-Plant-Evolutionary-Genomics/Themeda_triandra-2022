
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
<br/><br/>
**[3.1] Mapping data to the reference genome**

Bowtie2 v.2.3.4.3 (Langmead & Salzberg, 2012) was used to map the cleaned nucelar data to the TtPh16-4 reference genome. First this involve building a Bowtie database

`bowtie2-build TtPh16-4.fasta TtPh16-4.fasta`

Then map the data and generate sorted bam file

`bowtie2 -x TtPh16-4.fasta -1 SAMPLE_1_R1.fastq.gz -2 SAMPLE_1_R2.fastq.gz --no-unal -p 2 | samtools view -bS - > SAMPLE_1.bam`

`samtools sort SAMPLE_1.bam -o SAMPLE_1_SORTED.bam`

Example array submission script = mapping_array.sh

<br/><br/>
**References**
Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: a flexible trimmer for Illumina sequence data. Bioinformatics, 30, 2114-2120.

Langmead, B., & Salzberg, S. L. (2012). Fast gapped-read alignment with Bowtie 2. Nature Methods, 9, 357-359.

Patel, R. K., & Jain, M. (2012). NGS QC Toolkit: a toolkit for quality control of next generation sequencing data. PloS one, 7, e30619.

Schmieder, R., & Edwards, R. (2011). Quality control and preprocessing of metagenomic datasets. Bioinformatics, 27, 863-864.


