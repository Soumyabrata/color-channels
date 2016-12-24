# Systematic Study of Color Spaces and Components for the Segmentation of Sky/Cloud Images

With the spirit of reproducible research, this repository contains all the codes required to produce the results in the manuscript: S. Dev, Y. H. Lee, S. Winkler, Systematic Study of Color Spaces and Components for the Segmentation of Sky/Cloud Images, *Proc. IEEE International Conference on Image Processing (ICIP)*, Oct. 2014. 

Please cite the above paper if you intend to use whole/part of the code. This code is only for academic and research purposes.

## Manuscript
The author version of this manuscript is `manuscript.PDF`. 

## Code Organization
All codes are written in MATLAB. Thanks to [Florian Savoy](https://github.com/FSavoy) for editing the original version of the codes with better readability and higher efficiency. 

### Dataset
The dataset used in this manuscript is HYTA dataset from Li et. al, A Hybrid Thresholding Algorithm for Cloud Detection on Ground-Based Color Images, *Journal of Atmospheric and Oceanic Technology*, 2011. Please contact the respective authors for the dataset. Please save the dataset images and ground-truth maps in a new folder `./HYTA+GT`.

### Core functionality
* `bimod_degree_new.m` Calculates the Pearson's Bimodality Index of any vector.
* `extractChannels.m` Extracts all the related color channels used in this paper for a given image. 
* `pca_analysis_new.m` Performs Principal Component Analysis (PCA) on the color channels.
* `rectangleGrid.m` Generates the semi- rectangle grid used in the paper. 

### Reproducibility 
In addition to all the related codes, we have also shared the pre-computed results generated from HYTA dataset. The pre-computed files (in case HYTA dataset is not present) are contained in the folder `./preComputed`.

The program `main.m` is the main script, that reproduces all the results. It uses different helper scripts stored in the folder `helperScripts`. It also reproduces the figures and tables in this associated paper.
