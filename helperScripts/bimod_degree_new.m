function pbi = bimod_degree_new(in)
% This function calculates the Pearson's bimodal degree of a vector.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------

pbi = kurtosis(in, 1, 1) - power(skewness(in, 1, 1), 2);