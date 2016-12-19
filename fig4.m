% This plots the F-score distribution for 1- and 2-D color channels.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------
  
clear all; clc; 

addpath('./HYTA+GT/');
addpath('./helperscripts/');
addpath('./precomputed/');


Precision_range = xlsread('scorecard.xlsx', '2D-Summary', 'D:D');
Recall_range = xlsread('scorecard.xlsx', '2D-Summary', 'E:E');
FScore_range = xlsread('scorecard.xlsx', '2D-Summary', 'F:F');    
array1_range = xlsread('scorecard.xlsx', '2D-Summary', 'A:A');
array2_range = xlsread('scorecard.xlsx', '2D-Summary', 'B:B');
    
precision_1D = xlsread('scorecard.xlsx', '1D-Summary', 'B:B');
recall_1D = xlsread('scorecard.xlsx', '1D-Summary', 'C:C');
fscore_1D = xlsread('scorecard.xlsx', '1D-Summary', 'D:D');

    
% Making the precision matrix
precision_matrix=zeros(16,16);
recall_matrix=zeros(16,16);
fscore_matrix=zeros(16,16);

for a=1:120
   i= array1_range(a);
   j= array2_range(a);
   
   precision_matrix(i,j)=Precision_range(a);
   precision_matrix(j,i)=Precision_range(a);
   
   recall_matrix(i,j)=Recall_range(a);
   recall_matrix(j,i)=Recall_range(a);
   
   fscore_matrix(i,j)=FScore_range(a);
   fscore_matrix(j,i)=FScore_range(a);
   
end


for b=1:16
    precision_matrix(b,b)=precision_1D(b);
    recall_matrix(b,b)=recall_1D(b);
    fscore_matrix(b,b)=fscore_1D(b);
end


% Plotting the color matrix 
ws5=cell(16); RectCount=1;
my_cmap=flipud(gray(256));
new_cmap = flipud(my_cmap);

% Creating the small rectangles. 
% The rectangles are marked from bottom to top; and then left to right
figure;
axis off;
i=1; j=1;
for i=1:16
    %for j=1:(16-i+1)
    for j=(16-i+1):(16)
        ws5{RectCount}=rectangle('Position',[i ,j ,1,1]);    
        RectCount=RectCount+1;
    end
end

% Marking the legends on the top and the right
text(1,17+0.5,'c_{1}'); hold on;  text(16.2+1,15.5+1,'c_{1}');  hold on;
text(1+1,17+0.5,'c_{2}'); hold on;  text(16.2+1,15.5-1+1,'c_{2}');  hold on;
text(1+2,17+0.5,'c_{3}'); hold on;  text(16.2+1,15.5-2+1,'c_{3}');  hold on;
text(1+3,17+0.5,'c_{4}'); hold on;  text(16.2+1,15.5-3+1,'c_{4}');  hold on;
text(1+4,17+0.5,'c_{5}'); hold on;  text(16.2+1,15.5-4+1,'c_{5}');  hold on;
text(1+5,17+0.5,'c_{6}'); hold on;  text(16.2+1,15.5-5+1,'c_{6}');  hold on;
text(1+6,17+0.5,'c_{7}'); hold on;  text(16.2+1,15.5-6+1,'c_{7}');  hold on;
text(1+7,17+0.5,'c_{8}'); hold on;  text(16.2+1,15.5-7+1,'c_{8}');  hold on;
text(1+8,17+0.5,'c_{9}'); hold on;  text(16.2+1,15.5-8+1,'c_{9}');  hold on;
text(1+9,17+0.5,'c_{10}'); hold on;  text(16.2+1,15.5-9+1,'c_{10}');  hold on;
text(1+10,17+0.5,'c_{11}'); hold on;  text(16.2+1,15.5-10+1,'c_{11}');  hold on;
text(1+11,17+0.5,'c_{12}'); hold on;  text(16.2+1,15.5-11+1,'c_{12}');  hold on;
text(1+12,17+0.5,'c_{13}'); hold on;  text(16.2+1,15.5-12+1,'c_{13}');  hold on;
text(1+13,17+0.5,'c_{14}'); hold on;  text(16.2+1,15.5-13+1,'c_{14}');  hold on;
text(1+14,17+0.5,'c_{15}'); hold on;  text(16.2+1,15.5-14+1,'c_{15}');  hold on;
text(1+15,17+0.5,'c_{16}'); hold on;  text(16.2+1,15.5-15+1,'c_{16}');  hold on;


st_avg_area_matrix=reshape(fscore_matrix,1,16*16);

[~, ~, forwardRank] = unique(st_avg_area_matrix);
reverseRank = max(forwardRank) - forwardRank  + 1;
rankvalues_matrix=reshape(reverseRank,16,16); % Higher area=Lower rank
st_avg_rank_matrix=reshape(rankvalues_matrix,1,16*16);

a=sort(reshape(rankvalues_matrix,1,16*16));

rankvalues_matrix_st=stretch_range(rankvalues_matrix,1,256);

ColorCount=1;   inc=1;
for y=1:16

     for x=inc:(-1):1

        rc=round(rankvalues_matrix_st(x,y));
        rgb_equiv=my_cmap(rc,:);
        set(ws5{ColorCount}, 'FaceColor', rgb_equiv);
        ColorCount=ColorCount+1;
     end
    inc=inc+1;
end