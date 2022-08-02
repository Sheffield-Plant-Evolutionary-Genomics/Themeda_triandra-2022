## Generating a reference Themeda triandra genome

As part of this project we generated a *Themeda triandra* reference genome assemble for the TtPh16-4 accession collected from the Carranglan region of the Philippines (15°56'35.8“ N  121°00'26.2“ E). A PacBio library was prepared by The University of Sheffield Molecular Ecology Laboratory, and sequenced on two PacBio Sequel SMRT cells generating approximately 20.93 Gb of PacBio subread data (N50 = 5.61 kb).
<br/><br/>
[1] The initial assembly was generated using Canu v.2.0 (Koren et al., 2017) with default parameters

`canu  -p TTPH -d TTPHC useGrid=false maxThreads=16 maxMemory=252 genomeSize=0.85g -pacbio TTPH_pacbio_raw.fasta`

Example submission script = canu_TTPH.sh


[2] Plastid Genome assembly was preformed using NOVOPlasty v.4.2.1 (Dierckxsens et al., 2017) with default parmeters and a matK seed alignment. 

`perl NOVOPlasty4.3.1.pl -c config.txt`

Example submission script = cpGENOME.sh

Required Control file = config.txt

Required Seed alingment = Seed1.fasta 








**References**

Dierckxsens, N., Mardulyn, P., & Smits, G. (2017). NOVOPlasty: de novo assembly of organelle genomes from whole genome data. Nucleic acids research, 45, e18-e18.

Koren, S., Walenz, B. P., Berlin, K., Miller, J. R., Bergman, N. H., & Phillippy, A. M. (2017). Canu: scalable and accurate long-read assembly via adaptive k-mer weighting and repeat separation. Genome research, 27(5), 722-736.
