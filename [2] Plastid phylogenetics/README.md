
## Inferring the phylogenetic history of Themeda using whole chloroplast genomes
<br/><br/>

**[2.1] Assembling whole plastid genomes from short read Illumina data**

The plastid genomes were assembled using NOVOPlasty v.4.2.1 (Dierckxsens et al., 2017) Please see step **[1.2] Assembling the plastid genome** for detail. 
<br/><br/>

**[2.2] whole plastid alignments**

The plastid genomes were manually rearranged so that the short single copy and inverted repeat was in the same orientation for each individual using Geneious v.5.3.6 (Kearse et al., 2012) prior to being alingned with MAFFT v.7017 (Katoh et al., 2002).

`mafft --auto in > out`
<br/><br/>

**[2.3] Converting alignment from fasta to phy**

'perl Fasta2Phylip.pl in.fasta out.phy`

Required perl script = Fasta2Phylip.pl (by Wenjie Deng)
<br/><br/>
**[2.4] Inferring maximum likelihood phylogenies**

Maximum-likelihood phylogenetic trees with 100 bootstrap replicates were inferred using PhyML v.20120412 (Guindon et al., 2010), with the best-fit nucleotide substitution model selected with SMS v.1.8.1 (Lefort et al., 2017) for alingemnts with and without the inverted repear (IR) removed

`./sms.h -i ALIGNMENT -d nt -t -b 100`

Example submission script = cpTrees.sh

Required file list = files

**References**

Dierckxsens, N., Mardulyn, P., & Smits, G. (2017). NOVOPlasty: de novo assembly of organelle genomes from whole genome data. Nucleic acids research, 45, e18-e18.

Katoh, K., Misawa, K., Kuma, K. I., & Miyata, T. (2002). MAFFT: a novel method for rapid multiple sequence alignment based on fast Fourier transform. Nucleic acids research, 30, 3059-3066.

Kearse, M., Moir, R., Wilson, A., Stones-Havas, S., Cheung, M., Sturrock, S., ... & Drummond, A. (2012). Geneious Basic: an integrated and extendable desktop software platform for the organization and analysis of sequence data. Bioinformatics, 28, 1647-1649.
