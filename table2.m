% This script generates the PBI values
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------

% This function computes the various statistical values of the different
% color channels. Run this function only if the HYTA dataset is present.
clear all; clc;

addpath('./HYTA+GT/');
addpath('./helperscripts/');
addpath('./precomputed/');


%find_statistical_values_conc_image;   % HYTA datset should be present to run this statement.
% Uncomment the above line if the following .mat file is already present.
load concatenated_image_statistical_values.mat ;    % Pre-computed value for reproducibility.


% Computes the PBI values accordingly.
PBI_R=bimod_degree(R_cat);
PBI_G=bimod_degree(G_cat);
PBI_B=bimod_degree(B_cat);
PBI_H=bimod_degree(H_cat);
PBI_S=bimod_degree(S_cat);
PBI_V=bimod_degree(V_cat);
PBI_Y=bimod_degree(Y_cat);
PBI_I=bimod_degree(I_cat);
PBI_Q=bimod_degree(Q_cat);
PBI_L=bimod_degree(L_cat);
PBI_a=bimod_degree(a_cat);
PBI_b=bimod_degree(b_cat);
PBI_rb1=bimod_degree(rb1_cat);
PBI_rb2=bimod_degree(rb2_cat);
PBI_rb3=bimod_degree(rb3_cat);
PBI_C=bimod_degree(C_cat);

PBI=[PBI_R,PBI_G,PBI_B,PBI_H,PBI_S,PBI_V,PBI_Y,PBI_I,PBI_Q,PBI_L,PBI_a,PBI_b,PBI_rb1,PBI_rb2,PBI_rb3,PBI_C];
  

disp ('The PBI values are: ');
disp (PBI')
