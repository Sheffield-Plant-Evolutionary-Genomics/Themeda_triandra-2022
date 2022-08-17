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

**[5.6] Generating a desnsitree**

A DensiTree v.2.2.7 (Bouckaert, 2010) plot was made for transformmed BUSCO genes trees using the chronopl function (lambda = 1) as part of the ape v.5.2 (Paradis & Schliep, 2019) package in R v.3.4.3. Below are the R command used for each tree:

`library(ape)`

`tree1<-read.tree("GENE1.tree")`

`tree2<-root(tree1,c("T102_Jobson_2028","T130_Jobson_2520"),resolve.root = TRUE)`

`write.tree(tree2, file = "GENE1_rooted.tree")`

`tree3<-chronopl(tree2, 1, age.min = 1, age.max = NULL,node = "root", S = 1, tol = 1e-8,CV = FALSE, eval.max = 500, iter.max = 500)`

`write.tree(tree3, file = "GENE1_chronopl.tree")`

the chronopl.trees were then concatenated into a single file `cat *chronopl.tree > BUSCO_chronopl.tree` before being process with DensiTree

<br/><br/>
**[5.7] Generating Coalescece spcies tree**

A coalescence species tree was generated from the individual gene trees using ASTRAL v.5.7.5 (Zhang et al., 2018) after collapsing branches with < 10% bootstrap support using Newick utilities v.1.6 (Junier & Zdobnov, 2010). Phyparts v.0.0.1 (Smith et al., 2015) was used to evaluate individual gene tree support for the coalescence species tree. The results were visualised using the phypartspiecharts.py python script written by M. Johnson (available from: https://github.com/mossmatters/phyloscripts/blob/master/phypartspiecharts).

collapsing branches with < 10% bootstrap support

`newick_utils-master/src/./nw_ed  concatenated_BUSCO_gene_trees.txt 'i & b<=10' o > BUSCO-BS10.tree`

Generating astral tree

`java -jar astral.5.7.5.jar -i BUSCO-BS10.tree -o astral.BUSCO-BS10.tree 2> astral.log`

`java -jar astral.5.7.5.jar -q o astral.BUSCO-BS10.tree -i BUSCO-BS10.tree -t 1 -o astral.scored-t1.BUSCO-BS10.tree 2> astral.t1.log`

`java -jar astral.5.7.5.jar -q o astral.BUSCO-BS10.tree -i BUSCO-BS10.tree -t 2 -o astral.scored-t2.BUSCO-BS10.tree 2> astral.t2.log`

Evaluating support for astral. The astral.BUSCO-BS10.tree was manually rooted before the next step, and the rooted gene trees from **[5.6] Generating a desnsitree** were used, all placein a directory called `THEM_ROOTED_GENE_TREES`. The `-s` paramater was used with various thresholds. 

java -jar phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -d THEM_ROOTED_GENE_TREES -m rooted_astral.tree -a 1 -v -o Them_phyparts10 -s 10`

the results were then visalised using the phypartspiecharts.py python script

`conda activate ete3`

`python phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar rooted_astral Them_phyparts10 1288`
 
<br/><br/>
**References**

Bouckaert, R. R. (2010). DensiTree: making sense of sets of phylogenetic trees. Bioinformatics, 26, 1372-1373.

Junier, T., & Zdobnov, E. M. (2010). The Newick utilities: high-throughput phylogenetic tree processing in the UNIX shell. Bioinformatics, 26, 1669-1670.

Kearse, M., Moir, R., Wilson, A., Stones-Havas, S., Cheung, M., Sturrock, S., ... & Drummond, A. (2012). Geneious Basic: an integrated and extendable desktop software platform for the organization and analysis of sequence data. Bioinformatics, 28, 1647-1649.

Nguyen, L. T., Schmidt, H. A., Von Haeseler, A., & Minh, B. Q. (2015). IQ-TREE: a fast and effective stochastic algorithm for estimating maximum-likelihood phylogenies. Molecular Biology and Evolution, 32, 268-274.

Paradis, E., & Schliep, K. (2019). ape 5.0: an environment for modern phylogenetics and evolutionary analyses in R. Bioinformatics, 35, 526-528.

Smith, S. A., Moore, M. J., Brown, J. W., & Yang, Y. (2015). Analysis of phylogenomic datasets reveals conflict, concordance, and gene duplications with examples from animals and plants. BMC Evolutionary Biology, 15, 1-15.

Zhang, C., Rabiee, M., Sayyari, E., & Mirarab, S. (2018). ASTRAL-III: polynomial time species tree reconstruction from partially resolved gene trees. BMC Bioinformatics, 19, 15-30.
