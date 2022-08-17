## Themeda population genomics. 

This details conducting various population genomics, including generating PCA's from SNP data, admixture analyses, calulating Fst and the D-Statistic / f4-ratio.
<br/><br/>

**[1] Calculating genotype likelihoods**

Genotype likelihoods were estimated across the entire TtPh16-4 nuclear genome using ANGSD v.0.929-13-gb5c4df3 (Korneliussen et al., 2014) and the bowtie2 alignments generated in step **[3.2] Mapping data to the reference genome** above with organelle sequences excluded.

`samtools view -h Sample1_sorted.bam | awk '{if($3 != "TTPH-cpGENOME" && $3 != "TTPH-mtGENOME"){print $0}}' | samtools view -Sb - > no-organelle/Sample1_sorted.bam`

`angsd  -b list.bams -ref TtPh16-4.fasta  -uniqueOnly 1 -nThreads 4 -remove_bads 1 -trim 0 -C 50 -baq 1 -minMapQ 20 -minQ 20 -minInd 2 -docounts 1 -gl 1 -domajorminor 1 -domaf 1 -doglf 2 -dobcf 1 -dopost 1 -SNP_pval 1e-6 -dogeno 5 --ignore-RG 0`

<br/><br/>
**[1] Calculating PCA**

ANGSD was used to infer a PCA from the SNP data

`pcangsd -beagle angsdput.beagle.gz -admix -o pcangsd.default`
<br/><br/>

**References**

Korneliussen, T. S., Albrechtsen, A., & Nielsen, R. (2014). ANGSD: analysis of next generation sequencing data. BMC Bioinformatics, 15, 1-13.
