function [PBI] = bimod_degree(InputArray)
% This function calculates the Pearson's bimodal degree of a vector.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------


PBI=kurtosis(InputArray)-power(skewness(InputArray),2);