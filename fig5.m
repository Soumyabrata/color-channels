% This plots the comparison with state
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------
 
clear all; clc; 

addpath('./HYTA+GT/');
addpath('./helperscripts/');
addpath('./precomputed/');

figure;

% These figures are found from 'scorecard.xlsx'
D1=[0.8448136063 0.9202980031 0.8550608875];
D2=[0.8651372063 0.9209823375 0.8747497344];

SOA=[0.9 0.87 0.85];
mat=cat(1,D1,D2,SOA);

bar(mat,'grouped');
set(gca,'XTickLabel',[' c13  ';'c8-c13';' HYTA ']);
ylim([0.75 0.96]);
legend('Precision','Recall','F-score')