# Systematic Study of Color Spaces and Components for the segmentation of sky/cloud images

With the spirit of reproducible research, this repository contains all the codes required to produce the results in the manuscript: `S. Dev, Y. H. Lee, S. Winkler, Systematic Study of Color Spaces and Components for the segmentation of sky/cloud images, *Proc. IEEE International Conference on Image Processing (ICIP)*, Oct. 2014`. 

Please cite the above paper if you intend to use whole/part of the code. This code is only for academic and research purposes.

### Authors
* Soumyabrata Dev, Nanyang Technological University, Singapore
* Yee Hui Lee, Nanyang Technological University, Singapore
* Stefan Winkler, Advanced Digital Sciences Center, University of Illinois at Urbana-Champain, Singapore

### Manuscript
The author version of this manuscript is `manuscript.PDF`. 

## Code Organization
All codes are written in MATLAB. 

### Dataset
The dataset used in this manuscript is HYTA dataset from Li et. al, A Hybrid Thresholding Algorithm for Cloud Detection on Ground-Based Color Images, *Journal of Atmospheric and Oceanic Technology*, 2011. Please contact the respective authors for the dataset. Please save the dataset images and ground-truth maps in a new folder `HYTA+GT`.

### Core functionality
* `bimod_degree.m` Calculates the Pearson's Bimodality Index of any vector.
* `biplot_modified.m` Generates the X- and Y- co-ordinates of a biplot figure. This is a modification of the in-built MATLAB script `biplot.m`.
* `find_statistical_values_conc_image.m` Generates various parameters associated with the concatenated distribution of the color channels. 
* `pca_analysis.m` Performs Principal Component Analysis (PCA) on the color channels.
* `RGBPlane.m` Extracts the red-, green- and blue- color channels of any sample image.
* `stretch_range.m` Normalizes a regular matrix/vector between two user-defined limits. 

### Reproducibility 
In addition to all the related codes, we have also shared the pre-computed results generated from HYTA dataset. The pre-computed files (in case HYTA dataset is not present) are contained in the folder `precomputed`.

The following lines will show the process to reproduce the figures and tables in this associated paper.

#### Table 2
Run the script `table2.m`

#### Figure 2
Run the script `fig2.m`

#### Figure 3
Run the script `fig3.m`

#### Figure 4
Run the script `fig4.m`

#### Figure 5
Run the script `fig5.m`
