% This script generates the PBI values shown in Table 2.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------
clear all; clc; 

addpath('./HYTA+GT/');
addpath('./helperscripts/');
addpath('./precomputed/');

%find_statistical_values_conc_image;  % HYTA datset should be present to run this statement.
% Uncomment the above line if the following .mat file is already present.
load concatenated_image_statistical_values.mat ;    % Pre-computed value for reproducibility.


% Calculation for concatenated distribution. This creates the distribution
% for the dataset obtained by concatenating all images of HYTA. 
R_norm=(R_cat-R_mean)/(R_std);
G_norm=(G_cat-G_mean)/(G_std);
B_norm=(B_cat-B_mean)/(B_std);
    
H_norm=(H_cat-H_mean)/(H_std);
S_norm=(S_cat-S_mean)/(S_std);
V_norm=(V_cat-V_mean)/(V_std);
    
Y_norm=(Y_cat-Y_mean)/(Y_std);
I_norm=(I_cat-I_mean)/(I_std);
Q_norm=(Q_cat-Q_mean)/(Q_std);
    
L_norm=(L_cat-L_mean)/(L_std);
a_norm=(a_cat-a_mean)/(a_std);
b_norm=(b_cat-b_mean)/(b_std);
    
rb1_norm=(rb1_cat-rb1_mean)/(rb1_std);
rb2_norm=(rb2_cat-rb2_mean)/(rb2_std);
rb3_norm=(rb3_cat-rb3_mean)/(rb3_std);    
    
C_norm=(C_cat-C_mean)/(C_std);
    
% All these values are mean centered
V1=R_norm-mean(R_norm);
V2=G_norm-mean(G_norm);
V3=B_norm-mean(B_norm);
    
V4=H_norm-mean(H_norm);
V5=S_norm-mean(S_norm);
V6=V_norm-mean(V_norm);
    
V7=Y_norm-mean(Y_norm);
V8=I_norm-mean(I_norm);
V9=Q_norm-mean(Q_norm);
    
V10=L_norm-mean(L_norm);
V11=a_norm-mean(a_norm);
V12=b_norm-mean(b_norm);
    
V13=rb1_norm-mean(rb1_norm);
V14=rb2_norm-mean(rb2_norm); 
V15=rb3_norm-mean(rb3_norm);
    
V16=C_norm-mean(C_norm);

Comb=cat(2,V1',V2',V3',V4',V5',V6',V7',V8',V9',V10',V11',V12',V13',V14',V15',V16');
    
CovMat=cov(Comb);       % calculating the covariance matrix
    
[Ve,De] = eig(CovMat);      % calculating the eigen values

ais=diag(De);

    
% p1 p2 p3 are the relative loadings (co-efficients for the input
% variables)
p1=Ve(:,16);
p2=Ve(:,15);
p3=Ve(:,14);

% Higher dimensional principal components
p4=Ve(:,13);
p5=Ve(:,12);
p6=Ve(:,11);
    
p7=Ve(:,10);
p8=Ve(:,9);
p9=Ve(:,8);
    
p10=Ve(:,7);
p11=Ve(:,6);
p12=Ve(:,5);
    
p13=Ve(:,4);
p14=Ve(:,3);
p15=Ve(:,2) ;   
p16=Ve(:,1);
    
%   Re-projecting the data points
c1=Ve(:,16)'*Comb';
c2=Ve(:,15)'*Comb';
c3=Ve(:,14)'*Comb';
    
c4=Ve(:,13)'*Comb';
c5=Ve(:,12)'*Comb';
c6=Ve(:,11)'*Comb';
    
c7=Ve(:,10)'*Comb';
c8=Ve(:,9)'*Comb';
c9=Ve(:,8)'*Comb'; 

c10=Ve(:,7)'*Comb';
c11=Ve(:,6)'*Comb';
c12=Ve(:,5)'*Comb';
    
c13=Ve(:,4)'*Comb';
c14=Ve(:,3)'*Comb';
c15=Ve(:,2)'*Comb';    
c16=Ve(:,1)'*Comb';
    
Re_projected=cat(2,c1',c2',c3',c4',c5',c6',c7',c8',c9',c10',c11',c12',c13',c14',c15',c16');

[COEFF,latent,explained] = pcacov(CovMat);
    
% For concatenated distribution
conc_pca_dist=explained';



    
    
%pca_analysis; % HYTA datset should be present to run this statement.
% Uncomment the above line if the following .mat file is already present.
load pca_analysis_variables.mat;    % Pre-computed value for reproducibility.


pca_srt = sortrows(pca_matrix',-1);
demo_row=zeros(1,16);
figure;
pca_srt_new=cat(1,pca_srt,demo_row,demo_row,conc_pca_dist); % This variable comes from exe_part.m
bar(pca_srt_new,'stacked');
shading flat
cmap = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1];
colormap([cmap])
caxis([1 7]);
axis([0 37 50 100])
legend('1st','2nd','3rd','4th','5th','6th','location','southwest')
set(gca,'xtick',[]);
set(gca,'fontsize',12);
ylabel('Relative variance of principal components [%]')



%%