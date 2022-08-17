## Inferring the phylogenetic history of Themeda using single copy nuclear genes

A reference-based approach was used to generate consensus sequences for single-copy nuclear genes to infer phylogenetic relationships. Our analysis focused on the Benchmarking Universal Single-Copy Orthologs in the poales_odb10 database identified in the TtPh16-4 genome (see step **[1.7] Assessing assembly quality** for details).

<br/><br/>
**[1.1] Identifying complete BUSCOs for phylogenetic analysis**

A custom shell script is used to process the output of the BUSCO program from the BUSCO sumamry and predicted genes files to identify complete BUSCOs, extract annotations, detemine their orientiation and calulate their length.

Shell script = `BUSCO_markers.sh`

