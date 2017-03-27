# Kitson_et_al_NMB (version 1.3)

In order to make our analyses fully reproducable we provide:
- [Jupyter notebooks](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/Jupyter_notebook) for processing raw read data into taxonomic assignments and exploring analysis parameters.
- [Rnotebook](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/blob/master/R_plotting_notebook_main_analysis.Rmd) for taking taxonomic assignment and read depth data from the Jupyter notebooks and plotting figures for the main manuscript.
[Rnotebooks](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/blob/master/R_plotting_notebook_appendix1.Rmd) for taking taxonomic assignment and read depth data from the Jupyter notebooks and plotting figures for Supplementary material appendix one.
- [data](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/data), e.g. metadata for annotation of plots and scripts for dowloading raw sequencing data.
- [raw diagrams](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/diagrams) as output by the R note books ready for annotation in Inkscape.
- [Supplementary material as described in the manuscript](https://github.com/HullUni-bioinformatics/Kitson_et_al_NMB/tree/master/supplementary_material)

Rmarkdown notebooks should be executed in the root of the cloned repository while Jupyter notebooks can be executed in their folder. All filepaths are correctly specified for the various analyses.

[metaBEAT](https://github.com/HullUni-bioinformatics/metaBEAT) (v0.97.7) was run in a [docker](https://hub.docker.com/r/chrishah/metabeat/) container. See the [metaBEAT github repository](https://github.com/HullUni-bioinformatics/metaBEAT) for installation and usage instructions.

***********************************************************************************************************

__A previous version of this repository (version 1.2) is archived: [![DOI](https://zenodo.org/badge/19905/HullUni-bioinformatics/Kitson_et_al_NMB.svg)](https://zenodo.org/badge/latestdoi/19905/HullUni-bioinformatics/Kitson_et_al_NMB)__

Repository version 1.2 contains scripts and supplementary data for [Kitson et al. - Nested metabarcoding manuscript](http://biorxiv.org/content/early/2015/12/23/035071). This earlier run now forms the basis of Supplementary meterial appendix one where we outline our first attepth to employ nested metabarcoding.
