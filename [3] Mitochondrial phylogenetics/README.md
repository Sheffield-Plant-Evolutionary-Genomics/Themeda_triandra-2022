
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

**[3.2] Mapping data to the reference genome**

Bowtie2 v.2.3.4.3 (Langmead & Salzberg, 2012) was used to map the cleaned nucelar data to the TtPh16-4 reference genome. First this involve building a Bowtie database

`bowtie2-build TtPh16-4.fasta TtPh16-4.fasta`

Then map the data and generate sorted bam file

`bowtie2 -x TtPh16-4.fasta -1 SAMPLE_1_R1.fastq.gz -2 SAMPLE_1_R2.fastq.gz --no-unal -p 2 | samtools view -bS - > SAMPLE_1.bam`

`samtools sort SAMPLE_1.bam -o SAMPLE_1_SORTED.bam`

Example array submission script = mapping_array.sh

<br/><br/>
**[3.3] generate a consensus sequence for the mtgenome**

To do this we used previously published shell scripts (from Dunning et al. (2019); adapted from Olofsson JK et al. (2016)). this generates a fasta alingment for genes/regionsof interest.   

Shell script = ShortRead_to_alignment-mtGENOME.sh

Required sample file = Themeda_sample_RAGTAG-MT

required CDS.BED file = mt-CDS.BED

required GENES.BED file = mt-gene.BED

required python script = countBases2.py

required python script = Remove_N_OnlySeqs.py

required perl script = split_annotated_seq.pl

<br/><br/>
**[3.4] Clean the mtGenome alingnment**

Ambigious bases `N` are substituted for gaps `-` and then trimAl v.1.2rev59 (Capella-Gutiérrez et al., 2009) is used to clean the alingment. 

`sed '/^>/ ! s/N/-/g' -i mtGENOME.fa` 

`trimal -in mtGENOME.fa  -out mtGENOME-clean.fa  -automated1`

<br/><br/>
**[3.5] Inferring a maximum likelihood phylogeny**

See step **[2.4] Inferring maximum likelihood phylogenies** for methods

<br/><br/>
**References**
Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: a flexible trimmer for Illumina sequence data. Bioinformatics, 30, 2114-2120.

Capella-Gutiérrez, S., Silla-Martínez, J. M., & Gabaldón, T. (2009). trimAl: a tool for automated alignment trimming in large-scale phylogenetic analyses. Bioinformatics, 25, 1972-1973.

Dunning, L. T., Olofsson, J. K., Parisod, C., Choudhury, R. R., Moreno-Villena, J. J., Yang, Y., ... & Christin, P. A. (2019). Lateral transfers of large DNA fragments spread functional genes among grasses. Proceedings of the National Academy of Sciences, 116, 4416-4425.

Langmead, B., & Salzberg, S. L. (2012). Fast gapped-read alignment with Bowtie 2. Nature Methods, 9, 357-359.

Olofsson, J. K., Bianconi, M., Besnard, G., Dunning, L. T., Lundgren, M. R., Holota, H., ... & Christin, P. A. (2016). Genome biogeography reveals the intraspecific spread of adaptive mutations for a complex trait. Molecular Ecology, 25, 6107-6123.

Patel, R. K., & Jain, M. (2012). NGS QC Toolkit: a toolkit for quality control of next generation sequencing data. PloS one, 7, e30619.

Schmieder, R., & Edwards, R. (2011). Quality control and preprocessing of metagenomic datasets. Bioinformatics, 27, 863-864.


