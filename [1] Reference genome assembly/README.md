## Generating a reference Themeda triandra genome

As part of this project we generated a *Themeda triandra* reference genome assemble for the TtPh16-4 accession collected from the Carranglan region of the Philippines (15°56'35.8“ N  121°00'26.2“ E). A PacBio library was prepared by The University of Sheffield Molecular Ecology Laboratory, and sequenced on two PacBio Sequel SMRT cells generating approximately 20.93 Gb of PacBio subread data (N50 = 5.61 kb).

<br/><br/>
**[1] Assembling the nculear genome**
The initial assembly was generated using Canu v.2.0 (Koren et al., 2017) with default parameters

`canu  -p TTPH -d TTPHC useGrid=false maxThreads=16 maxMemory=252 genomeSize=0.85g -pacbio TTPH_pacbio_raw.fasta`

Example submission script = canu_TTPH.sh

<br/><br/>
**[2] Assembling the plastid genome**
Plastid Genome assembly was preformed using NOVOPlasty v.4.2.1 (Dierckxsens et al., 2017) with default parmeters and a matK seed alignment. 

`perl NOVOPlasty4.3.1.pl -c config.txt`

Example submission script = cpGENOME.sh

Required Control file = config.txt

Required Seed alingment = Seed1.fasta 

<br/><br/>
**[3] Assembling the mitochondrial genome**

The mitochondrial genome was manually assembled from the PacBio contigs in Geneious v.5.3.6 (Kearse et al., 2012). In brief, the complete set of mitochondrial genes was extracted from a Sorghum bicolor mitochondrial assembly (NC_008360.1) and used as a Blastn v.2.8.1 query to identify the top-hit TtPh16-4 contig for each gene. These contigs were then truncated to the matching regions, retaining the intergenic regions if multiple loci were present on a single contig. Finally, duplicated regions were removed and the remaining contigs concatenated into a single pseudomolecule with gaps represented by 100 Ns. The completeness of the TtPh16-4 mitochondrial genome was estimated using the MITOFY v.1.3.1 webserver (Alverson et al., 2010).

`makeblastdb -in Canu_assembly.fasta -dbtype nucl`

`blastn -db Canu_assembly.fasta -query Gene_Features_NC_008360.1.fa -outfmt 6 > Mt_Blast_raw`

`cat Mt_Blast_raw | awk '!seen[$1]++' | cut -f 2 | sort | uniq | while read line ; do grep "$line" -A 1 Canu_assembly.fasta >>  mtScaffolds.fa ; done`

*The above command [and all downstream commands] requires the Canu_assembly.fasta file to be unwrapped. If this is not the case the file can be unwrapped with the following line:

`awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < Canu_assembly.fasta > Canu_assembly_unwrapped.fasta`

Then proceed to manual assembly in Geneious and MITOFY to estimate assembly completeness  
<br/><br/>

**[4] Masking organelle sequences in the reference genome.** 

Contigs containing organellar DNA were first identified using Blastn, with a  minimum alignment length of 1,000 bp and sequence similarity ≥ 99%. These scaffolds were then masked using RepeatMasker v.4.0.6 (Smit et al., 2013) with the organelle sequences as a custom database

`cat CpGenome.fa mtGenome.fa > organelle.fa`

`makeblastdb -in organelle.fa -dbtype nucl`

`blastn -db organelle.fa -query Canu_assembly.fasta -outfmt 6 > Blast_raw`

`cat Blast_raw | awk '$4 >=1000' | awk '$3 >=99' | cut -f 1 | sort | uniq > org_contam`

`cat org_contam | while read line ; do grep "$line" -A 1 Canu_assembly.fasta >> Scaffolds_to_mask.fasta ; done`

`cp Canu_assembly.fasta Scaffolds_no_mask.fasta`

`cat org_contam | while read line ; do sed '/'$line'/,+1 d' -i Scaffolds_no_mask.fasta ; done`

`RepeatMasker -nolow -norna -no_is -lib organelle.fa Scaffolds_to_mask.fasta`

`cat Scaffolds_no_mask.fasta Scaffolds_to_mask.fasta.masked > Themeda_triandra_TTPH-organelle-masked.fasta`


<br/><br/>

**[4] Homology based scaffolding.** 

The organelle masked contigs were then scaffolded in relation to the genome of Sorghum bicolor (GenBank accession: GCA_000003195.3), a closely related grass from the same tribe (Andropogoneae), using RagTag v.2.1.0 (Alonge et al., 2021).

`ragtag_scaffold.py -o OUTDIR -u chr_Sorghum.fasta Themeda_triandra_TTPH-organelle-masked.fasta`

Example submission script = ragtag.sh

<br/><br/>
**[6] Removing scaffolds with <500bp of sequence info.** 

We removed scaffolds that were either very short or had a majority of their coding sequences masked by RepeatMasker that <500bp of unambigious sequence remained.  

`sed '/^>/! s/N//g' ragtag.scaffold.fasta > ragtag.scaffold.fast.no_N` 

`perl fastaNamesSizes.pl ragtag.scaffold.fasta | awk '$2<500' | cut -f 1 > to_ambigious`

`cat to_ambigious | while read line ; do sed '/'$line'/,+1 d' -i ragtag.scaffold.fasta ; done`

Required perl script = fastaNamesSizes.pl (by Lionel Guy [lionel.guy@ebc.uu.se])

<br/><br/>
**[5] Assessing assembly quality.** 
The TtPh16-4 genome assembly completeness was estimated using BUSCO v.3.1.0 (Simão et al., 2015) with the poales_odb10 database, and by comparing the assembly size to the 1C genome size 

<br/><br/>
**References**
Alonge, M., Lebeigle, L., Kirsche, M., Aganezov, S., Wang, X., Lippman, Z., ... & Soyk, S. (2021). Automated assembly scaffolding elevates a new tomato system for high-throughput genome editing. BioRxiv.

Alverson, A. J., Wei, X., Rice, D. W., Stern, D. B., Barry, K., & Palmer, J. D. (2010). Insights into the evolution of mitochondrial genome size from complete sequences of Citrullus lanatus and Cucurbita pepo (Cucurbitaceae). Molecular biology and evolution, 27(6), 1436-1448.

Dierckxsens, N., Mardulyn, P., & Smits, G. (2017). NOVOPlasty: de novo assembly of organelle genomes from whole genome data. Nucleic acids research, 45, e18-e18.

Kearse, M., Moir, R., Wilson, A., Stones-Havas, S., Cheung, M., Sturrock, S., ... & Drummond, A. (2012). Geneious Basic: an integrated and extendable desktop software platform for the organization and analysis of sequence data. Bioinformatics, 28, 1647-1649.

Koren, S., Walenz, B. P., Berlin, K., Miller, J. R., Bergman, N. H., & Phillippy, A. M. (2017). Canu: scalable and accurate long-read assembly via adaptive k-mer weighting and repeat separation. Genome research, 27(5), 722-736.

Smit AFA, Hubley R, Green P (2013) RepeatMasker Open-4.0. <http://www.repeatmasker.org>.

