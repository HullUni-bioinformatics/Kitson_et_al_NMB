# Detecting host-parasitoid interactions in an invasive Lepidopteran using nested tagging DNA-metabarcoding (version 1.4)

James JN Kitson<sup>1,5</sup>, Christoph Hahn<sup>1,2</sup>, Richard J Sands<sup>3,4</sup>, Nigel A Straw<sup>3</sup>, Darren M Evans<sup>5</sup>, David H Lunt<sup>1</sup>
1. Evolutionary and Environmental Genomics Group, School of Environmental Sciences, University of Hull, Hull, UK
2. Institute of Zoology, Karl-Franzens-Universität, Graz, Austria.
3. Centre for Ecosystems, Society and Biosecurity, Forest Research, Alice Holt Lodge, Farnham, Surrey, UK
4. Centre for Biological Sciences, The University of Southampton, Highfield Campus, Southampton, UK.
5. School of Natural and Environmental Sciences, Newcastle University, Newcastle upon Tyne, UK.
***

This repository is associated with the above manuscript submitted to Molecular Ecology Resources. 

__The submitted version of this archive is archived: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1066005.svg)](https://doi.org/10.5281/zenodo.1066005)__

In order to make our analyses fully reproducable we provide:
- [Jupyter notebooks](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/Jupyter_notebook) for processing raw read data into taxonomic assignments and exploring analysis parameters.
- [Rnotebook](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/blob/master/R_plotting_notebook_main_analysis.Rmd) for taking taxonomic assignment and read depth data from the Jupyter notebooks and plotting figures for the main manuscript.
[Rnotebooks](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/blob/master/R_plotting_notebook_appendix1.Rmd) for taking taxonomic assignment and read depth data from the Jupyter notebooks and plotting figures for Supplementary material appendix one.
- [data](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/data), e.g. metadata for annotation of plots and scripts for dowloading raw sequencing data.
- [raw diagrams](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/diagrams) as output by the R note books ready for annotation in Inkscape.
- [Supplementary material as described in the manuscript](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/supplementary_material)

Rmarkdown notebooks should be executed in the root of the cloned repository while Jupyter notebooks can be executed in their folder. All filepaths are correctly specified for the various analyses.

[metaBEAT](https://github.com/HullUni-bioinformatics/metaBEAT) (v0.97.7) was run in a [docker](https://hub.docker.com/r/chrishah/metabeat/) container. See the [metaBEAT github repository](https://github.com/HullUni-bioinformatics/metaBEAT) for installation and usage instructions.
***
__A previous version of this repository (version 1.2) is archived: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.44522.svg)](https://doi.org/10.5281/zenodo.44522)__

Repository version 1.2 contains scripts and supplementary data for [Kitson et al. - Nested metabarcoding manuscript](http://biorxiv.org/content/early/2015/12/23/035071). This earlier run now forms the basis of Supplementary material appendix one where we outline our first attempt to employ nested metabarcoding.
