function [output_matrix] = stretch_range(input_matrix,min_value,max_value)
% This function stretches a matrix/array to lie in a particular range.
% Inputs: 
% input_matrix=the input matrix/array that needs stretching
% min_value, max_value = the final ranges of the matrix.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------


    [rows,cols]=size(input_matrix);
    minimum=min(min(input_matrix));
    maximum=max(max(input_matrix));
    range=maximum-minimum;
    
    output_matrix=zeros(rows,cols);
    
    for i=1:rows
       for j=1:cols
           output_matrix(i,j)=min_value+((input_matrix(i,j)-minimum)/range)*(max_value-min_value);
       end
    end