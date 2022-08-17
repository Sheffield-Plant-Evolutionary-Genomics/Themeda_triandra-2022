## Estiamting  ploidal level from low coverage resequencing data
<br/><br/>
The ploidy of each sample was estimated using HMMploidy (Soraggi et al., 2021), a method which has been developed to infer ploidy from low-depth sequencing data.

**[7.1] Generating a multi-sample mpileup file**

A multi-sample mpileup file was generated for HMMploidy from the bowtie2 alignments with SAMtools v.1.9 (Li et al., 2009), only including reads with a minimum read mapping quality (mapQ) of 20, counting anomalous read pairs and setting a maximum per-file depth of 100. This was then split into individual files for each chromosome. 

`samtools mpileup --bam-list list.bams -q 20 -f TtPh16-4.fasta --max-depth 100 -o TtPh16-4`

An example of extracting the data for one chromosome is shown below

`grep "^1_RagTag\s" TtPh16-4 > 1_RagTag`


<br/><br/>
**[7.2] Running HMMploidy**

HMMploidy was used to infer ploidy for each chromosome using the followign commands:

`python HMMploidy-master/./Genotype_Likelihoods.py 1_RagTag`

`Rscript HMMploidy-master/HMMploidy.R file=1_RagTag  maxPloidy=6  wind=100000  minInd=2`

and example array script to run all 10 chromosomes is included `hmmploidy-array-100kb.sh`

<br/><br/>
**[7.3] Processing HMMploidy results**

The percentage of 100 kb windows supporting each ploidy level was then calculated, ignoring those that were inferred to be haploid. It is a good idea to check thast all the chromosome results files ahve the same number of lines to ensure all samples were processed. Below are example commands for 1 chromosome


`cat 1_RagTag.HMMploidy | sed -e '/Sample:/{n;N;N;N;N;N;N;N;N;N;d}'  |  grep "Sample:" -A 1 | sed -e '/^--$/,+d' | grep -v "Fil" | sed 's/1\s2\s3\s4\s5\s6/NA/g' > 1_RagTag.HMMploidy.1`

`split -l 1 --numeric-suffixes=1 -a 4 1_RagTag.HMMploidy.1`

`sed 's/\s/\n/g' -i x00*`

`ls x* | while read line ; do grep -c "NA" "$line" >> count_"$line" ; done`

`ls x* | while read line ; do grep -c "1" "$line" >> count_"$line" ; done`

`ls x* | while read line ; do grep -c "2" "$line" >> count_"$line" ; done`

`ls x* | while read line ; do grep -c "3" "$line" >> count_"$line" ; done`

`ls x* | while read line ; do grep -c "4" "$line" >> count_"$line" ; done`

`ls x* | while read line ; do grep -c "5" "$line" >> count_"$line" ; done`

`ls x* | while read line ; do grep -c "6" "$line" >> count_"$line" ; done`

`paste count_x00* > V1.Results`

`rm count_x00* x* *HMMploidy.1`

The V1.Results rows are organised as NA, and 1x - 6x .. the colums are orderd by sample as they were in the `list.bams` file. We provide the example file `1_RagTag.HMMploidy` and and example shell script to run this as an array `hmmploidy-process-results.sh` 








<br/><br/>

**References**

Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., ... & Durbin, R. (2009). The sequence alignment/map format and SAMtools. Bioinformatics, 25, 2078-2079.

Soraggi, S., Rhodes, J., Altinkaya, I., Tarrant, O., Balloux, F., Fisher, M. C., & Fumagalli, M. (2021). HMMploidy: inference of ploidy levels from short-read sequencing data. bioRxiv.
