% This plots the area distribution for 1- and 2-D color channels.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------


clear all; clc; 

addpath('./HYTA+GT/');
addpath('./helperscripts/');
addpath('./precomputed/');


%find_statistical_values_conc_image;   % HYTA datset should be present to run this statement.
% Uncomment the above line if the following .mat file is already present.
load concatenated_image_statistical_values.mat ;    % Pre-computed value for reproducibility.


%pca_analysis; % HYTA datset should be present to run this statement.
% Uncomment the above line if the following .mat file is already present.
load pca_analysis_variables.mat;    % Pre-computed value for reproducibility.

ws5=cell(16); RectCount=1;
my_cmap=flipud(gray(256));
new_cmap = flipud(my_cmap);

    
% Creating the small rectangles. 
% The rectangles are marked from bottom to top; and then left to right
figure;
axis off;

for i=1:16
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

color_index=zeros(16,16);
min_value=min(min(area_matrix));
max_value=max(max(area_matrix));

for u=1:16
    for v=1:16
        color_index(u,v)=1+round(((area_matrix(u,v)-min_value)/(max_value-min_value))*255);
    end
end

st_data_matrix=reshape(area_matrix,1,16*16);

a=sort(reshape(color_index,1,16*16),'descend');

ColorCount=1;   inc=1;
for y=1:16

     for x=inc:(-1):1

        rc=color_index(x,y);

        rgb_equiv=new_cmap(rc,:);
        
        set(ws5{ColorCount}, 'FaceColor', rgb_equiv);
        
        % Plotting the values of the data matrix into the
        % rectangular plots
        ColorCount=ColorCount+1;
     end
    inc=inc+1;
end

