## Inferring the phylogenetic history of Themeda using single copy nuclear genes

A reference-based approach was used to generate consensus sequences for single-copy nuclear genes to infer phylogenetic relationships. Our analysis focused on the Benchmarking Universal Single-Copy Orthologs in the poales_odb10 database identified in the TtPh16-4 genome (see step **[1.7] Assessing assembly quality** for details).

<br/><br/>
**[5.1] Identifying complete BUSCOs for phylogenetic analysis**

A custom shell script is used to process the output of the BUSCO program from the BUSCO sumamry and predicted genes files to identify complete BUSCOs, extract annotations, detemine their orientiation and calulate their length.

Shell script = `BUSCO_markers.sh`

<br/><br/>
**[5.2] generate BUSCO gene alingemnts**
This uses the sorted BAM files generated in step **[3.2] Mapping data to the reference genome** and the same shells scripts in **[3.3] generate a consensus sequence for the mtgenome** For convenice i have included the shell scripts used for this specific step as it shows how the required BED files are linked t those generated in the **[5.1] Identifying complete BUSCOs for phylogenetic analysis** step 

Shell script = `ShortRead_to_alignment-BUSCO.sh`

Required sample file = `Themeda_sample_RAGTAG-MT`

other required files see  **[3.3] Generate a consensus sequence for the mtgenome**

<br/><br/>
**[5.3] Process BUSCO gene alingemnts**

The alignments were filtered to remove those of unusal length, remove short seqeunces, filter by number of taxa, and remove short alingments. We also cleaned the alingments as in step **[3.4] Clean the mtGenome alingnment**. This was all done with a custom shells script.

Shell script = `Process-alignments.sh`

Required perl script = `fastaNamesSizes.pl` (by Lionel Guy)

<br/><br/>
**[5.4] Concatenated nuclear tree**

The indivdual gene sequences were concatenated in Geneious v.5.3.6 (Kearse et al., 2012) and a ML tree was inferred with IQtree v.1.6.3 (Nguyen et al., 2015)

`iqtree -s Concatenated_BUSCO.fasta -bb 1000 -nt 4`

<br/><br/>
**[5.5] Indidual ML gene trees**

This was done as in step **[2.3] Converting alignment from fasta to phy** and **[2.4] Inferring maximum likelihood phylogenies**. An example array submission script is included. 

Shell script = `sms_trees_array.sh`

<br/><br/>

**[5.5] Generating Coalescece spcies tree**

A coalescence species tree was generated from the individual gene trees using ASTRAL v.5.7.5 (Zhang et al., 2018) after collapsing branches with < 10% bootstrap support using Newick utilities v.1.6 (Junier & Zdobnov, 2010). Phyparts v.0.0.1 (Smith et al., 2015) was used to evaluate individual gene tree support for the coalescence species tree. The results were visualised using the phypartspiecharts.py python script written by M. Johnson (available from: https://github.com/mossmatters/phyloscripts/blob/master/phypartspiecharts).
 

**References**

Junier, T., & Zdobnov, E. M. (2010). The Newick utilities: high-throughput phylogenetic tree processing in the UNIX shell. Bioinformatics, 26, 1669-1670.

Kearse, M., Moir, R., Wilson, A., Stones-Havas, S., Cheung, M., Sturrock, S., ... & Drummond, A. (2012). Geneious Basic: an integrated and extendable desktop software platform for the organization and analysis of sequence data. Bioinformatics, 28, 1647-1649.

Nguyen, L. T., Schmidt, H. A., Von Haeseler, A., & Minh, B. Q. (2015). IQ-TREE: a fast and effective stochastic algorithm for estimating maximum-likelihood phylogenies. Molecular Biology and Evolution, 32, 268-274.

Smith, S. A., Moore, M. J., Brown, J. W., & Yang, Y. (2015). Analysis of phylogenomic datasets reveals conflict, concordance, and gene duplications with examples from animals and plants. BMC Evolutionary Biology, 15, 1-15.

Zhang, C., Rabiee, M., Sayyari, E., & Mirarab, S. (2018). ASTRAL-III: polynomial time species tree reconstruction from partially resolved gene trees. BMC Bioinformatics, 19, 15-30.
