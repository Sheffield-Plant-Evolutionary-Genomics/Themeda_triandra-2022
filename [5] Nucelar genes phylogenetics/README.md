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
**[5.3] Clean BUSCO gene alingemnts**

The alignments were cleaned using as in step **[3.4] Clean the mtGenome alingnment** 

<br/><br/>
**[5.4] Concatenated nuclear tree**

The indivdual gene sequences were concatenated in Geneious v.5.3.6 (Kearse et al., 2012) and a ML tree was inferred with IQtree v.1.6.3 (Nguyen et al., 2015)

'iqtree -s Concatenated_BUSCO.fasta -bb 1000 -nt 4'



<br/><br/>

**References**

Kearse, M., Moir, R., Wilson, A., Stones-Havas, S., Cheung, M., Sturrock, S., ... & Drummond, A. (2012). Geneious Basic: an integrated and extendable desktop software platform for the organization and analysis of sequence data. Bioinformatics, 28, 1647-1649.

Nguyen, L. T., Schmidt, H. A., Von Haeseler, A., & Minh, B. Q. (2015). IQ-TREE: a fast and effective stochastic algorithm for estimating maximum-likelihood phylogenies. Molecular Biology and Evolution, 32, 268-274.

