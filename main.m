%% MAIN SCRIPT

clear all; clc; 

addpath('./HYTA+GT/');
addpath('./helperScripts/');
addpath('./preComputed/');

%% Defining the color channels and reading the images

disp('Extracting color channels: ')
disp('R, G, B, H, S, V, Y, I, Q, L*, a*, b*, R/B, R-B, B-R/B+R, C');

folder = './HYTA+GT/images/';
files = dir([folder, '*.jpg']);

pixels = []; % Matrix containing all pixels values (16 columns for each channel)
pixelsChannels = {}; % Structure containing the values separately per image

for i = 1:length(files)   

    filename = files(i).name;
    image = imread([folder, filename]);
    
    pixelsChannels{i} = extractChannels(image);
    
    image = imresize(image, 0.3); % Resizing for faster computation
    pixels = [pixels ; extractChannels(image)];
    
end

%% Computing statistical values accross all color channels

percentile5channels = prctile(pixels, 5, 1);
disp('5th precentile accross color channels: ');
disp(percentile5channels');

perdentile95channels = prctile(pixels, 95, 1);
disp('95th precentile accross color channels: ');
disp(percentile5channels');

meanChannels = mean(pixels, 1);
disp('Mean accross color channels: ');
disp(percentile5channels');

stdChannels = std(pixels, 1);
disp('Std accross color channels: ');
disp(percentile5channels');


%% PCA analysis

% On the pixels of all images concatenated
[p_conc, c_conc, pca_dist_conc] = pca_analysis_new(pixels, meanChannels, stdChannels);
    
pca_dist_images = zeros(16, length(files));
p_images = zeros(16, 16, length(files));
% On each image separately
for i=1:length(files)
   
    [p, c, pca_dist] = pca_analysis_new(pixelsChannels{i}, meanChannels, stdChannels);
    pca_dist_images(:, i) = pca_dist;
    p_images(:, :, i) = p;
    
end


%% ===================================================
% In case HYTA dataset is not present, please load the following .mat file
load preComputed.mat;


%% Bimodality index of the color channels (Table 2)

pbi = bimod_degree_new(pixels);
disp('Bimodality indexes accross color channels');
disp(pbi');

%% Generating figure 2
% Distribution of the variance across the principal components for all 
% images of the database. The separate bar on the right shows the variance
% distribution for the concatenation of all images of the entire database.

pca_sorted = sortrows(pca_dist_images', -1);
white_gap = zeros(2,16);

figure;
bars = [pca_sorted ; white_gap ; pca_dist_conc'];
bar(bars, 'stacked');
shading flat
cmap = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1];
colormap(cmap);
caxis([1 7]);
axis([0 37 50 100]);
legend('1st','2nd','3rd','4th','5th','6th','location','southwest');
set(gca,'xtick',[]);
set(gca,'fontsize',12);
ylabel('Relative variance of principal components [%]');

%% Generating figure 3
% Distribution of area AOB for all input vector pairs, where OA and OB are 
% two color channels. The brightness of each square represents the area 
% captured by the corresponding pair.

%coefs = p_images(:, 1:2, length(files)); % TODO Only last image considered?

coefs = p_conc(:,1:2); %concatenate image

% Code from biplot matlab function code (lines 122 to 124)
[p,d] = size(coefs);
[~,maxind] = max(abs(coefs),[],1);
colsign = sign(coefs(maxind + (0:p:(d-1)*p)));
coefs = bsxfun(@times,coefs,colsign);

biplotPoints = [coefs(:,1) coefs(:,2)];

% Generating the grid of vectors
[B1, A1] = meshgrid(biplotPoints(:,1), biplotPoints(:,1));
[B2, A2] = meshgrid(biplotPoints(:,2), biplotPoints(:,2));
A = cat(3, A1, A2);
B = cat(3, B1, B2);

% Computing the areas of the respective triangles
normsA = sqrt(sum(A.^2, 3));
normsB = sqrt(sum(B.^2, 3));


cosTheta = dot(A, B, 3)./(normsA .* normsB);
sinTheta = sqrt(1 - power(cosTheta, 2));
areas = (normsA .* normsB .* sinTheta)./2;

% Plotting the values of the data matrix into the rectangular plots
figure;
rectangles = rectangleGrid();

minVal = min(areas(:));
maxVal = max(areas(:));
gray_shade = (areas - minVal)./((maxVal - minVal));

count = 1;
for y = 1:16
     for x = y:-1:1
        color = repmat(gray_shade(x, y), [1, 3]);
        set(rectangles{count}, 'FaceColor', color);
        count = count+1;
     end
end



%% Generating figure 4

% Pre-computed precision, recall and f-score values
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


% Plotting the values of the fscore matrix into the rectangular plots
figure;
rectangles = rectangleGrid();

minVal = min(fscore_matrix(:));
maxVal = max(fscore_matrix(:));
gray_shade = (fscore_matrix - minVal)./((maxVal - minVal));

count = 1;
for y = 1:16
     for x = y:-1:1
        color = repmat(gray_shade(x, y), [1, 3]);
        set(rectangles{count}, 'FaceColor', color);
        count = count+1;
     end
end



%% Generating figure 5

figure;

% These figures are found from 'scorecard.xlsx'
D1=[0.8448136063 0.9202980031 0.8550608875];
D2=[0.8651372063 0.9209823375 0.8747497344];

SOA=[0.9 0.87 0.85];
mat=cat(1,D1,D2,SOA);

bar(mat,'grouped');
set(gca,'XTickLabel',[' c13  ';'c8-c13';' HYTA ']);
ylim([0.75 0.96]);
legend('Precision','Recall','F-score');


%%




