# Data files with descriptions as follows

### metaBEAT associated files
OPM_nest_associates.gb - This is a genbank format file of sequences obtained from non-OPM organisms dissected out of OPM nests.

Thaumetopoea.gb - This is a genbank format file of all published Thaumetopoea spp COX1 sequences.

positive.gb - This is a genbank format file of sequences from organisms used as PCR positives.

PCR_primers.fasta - This file contains the target specific region of the PCR primers and is used in the trimming section of the metaBEAT pipline.

QUERYmap - This file is used in the metaBEAT pipeline to define the MID sequences for each nested sample and the relative filepath to the library containing it.

REFmap - Same as Querymap but provides filepaths for metaBEAT to find our custom databases.

### R associated files
sample_metadata.txt - This is a modified version of QUERYmap used to apply plate data to sample names when plotting taxonomic assigments by well in R.
