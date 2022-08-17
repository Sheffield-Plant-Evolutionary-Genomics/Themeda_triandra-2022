## Estimating positive selection in chloroplast genes
<br/><br/>
**[8.1] Pairwise dn/ds**

Pairwise estimation of the ratio (ω) of synonymous (dS) and non-synonymous (dN) substitutions between sequences was calculated using the Yang and Nielson (2000) using 2 representative sequences.

`yn00 yn00.ctl`

required control file = `yn00.ctl`

required alignment file = `yn00.phy`

<br/><br/>
**[8.2] site wise dn/ds**

Site (M1a and M2a) models were used to infer if a gene was evolving under significant positive selection were implemented in codeml, distributed as part of the paml v.4.9j package (Yang, 2007). For these models we used the topology of the whole chloroplast genome tree.  

`codeml M1a_M2a.ctl`

required control file = `M1a_M2a.ctl`

required alignment file = `rpoC2_26554.phy`

required tree file = `Tree.Nwk`

A Likelihood ratio tests was used to compare models (df = 2) 

<br/><br/>
**[8.2] branch-site wise dn/ds**

Branch-site models (BSA and BSA1) models were used to infer if a gene was evolving under significant positive selection were implemented in codeml, distributed as part of the paml v.4.9j package (Yang, 2007). For these models we used the topology of the whole chloroplast genome tree. below is an example for a single branch.  

`codeml M1a_M2a.ctl`

required control file = `CP-Branch1.Nwk.ctl`

required alignment file = `rpoC2_26554.phy`

required tree file = `CP-Branch1.Nwk`

A Likelihood ratio tests was used to compare models (df = 1)

<br/><br/>
**References**


Yang, Z., & Nielsen, R. (2000). Estimating synonymous and nonsynonymous substitution rates under realistic evolutionary models. Molecular Biology and Evolution, 17, 32-43.


Yang, Z. (2007). PAML 4: phylogenetic analysis by maximum likelihood. Molecular Biology and Evolution, 24, 1586-1591.
