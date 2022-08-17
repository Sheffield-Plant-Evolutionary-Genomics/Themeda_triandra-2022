## Estiamting  ploidal level from low coverage resequencing data
<br/><br/>
The ploidy of each sample was estimated using HMMploidy (Soraggi et al., 2021), a method which has been developed to infer ploidy from low-depth sequencing data.

**[7.1] Generating a multi-sample mpileup file**

A multi-sample mpileup file was generated for HMMploidy from the bowtie2 alignments with SAMtools v.1.9 (Li et al., 2009), only including reads with a minimum read mapping quality (mapQ) of 20, counting anomalous read pairs and setting a maximum per-file depth of 100. This was then split into individual files for each chromosome. 

`samtools mpileup --bam-list list.bams -q 20 -f TtPh16-4.fasta --max-depth 100 -o TtPh16-4`

An example of extracting the data for one chromoms is shown below

`grep "^1_RagTag\s" TtPh16-4 > 1_RagTag`



<br/><br/>

**References**

Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., ... & Durbin, R. (2009). The sequence alignment/map format and SAMtools. Bioinformatics, 25, 2078-2079.

Soraggi, S., Rhodes, J., Altinkaya, I., Tarrant, O., Balloux, F., Fisher, M. C., & Fumagalli, M. (2021). HMMploidy: inference of ploidy levels from short-read sequencing data. bioRxiv.
