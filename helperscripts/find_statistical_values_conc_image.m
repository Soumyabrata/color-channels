function find_statistical_values_conc_image
% This script generates the statistical values of concatenated
% distribution.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------


% Insert here the entire path of HYTA images.
Files=dir('./HYTA+GT/images/*.jpg');



R_cat=[];   G_cat=[];   B_cat=[];
H_cat=[];   S_cat=[];   V_cat=[];
Y_cat=[];   I_cat=[];   Q_cat=[];
L_cat=[];   a_cat=[];   b_cat=[];
rb1_cat=[]; rb2_cat=[]; rb3_cat=[];
C_cat=[];

for kot=1:length(Files)   

    FileNames=Files(kot).name;
    InputImage_org=imread(['./HYTA+GT/images/',FileNames]);    
    InputImage=imresize(InputImage_org,0.3); % Resizing for faster computation
    
    % Extracting different color channnels
    [red,green,blue] = RGBPlane(InputImage);
    [rows,cols]=size(red);    
  
    
    %LAB Color model
    colorTransform = makecform('srgb2lab');
    lab = applycform(InputImage, colorTransform);
    labd = lab2double(lab);
    L_Image = labd(:, :, 1);  % Extract the L image.
    A_Image = labd(:, :, 2);  % Extract the A image.
    B_Image = labd(:, :, 3);  % Extract the B image.
    St_L=reshape(L_Image,1,rows*cols);
    St_A=reshape(A_Image,1,rows*cols);
    St_B=reshape(B_Image,1,rows*cols);

    St_Red=(reshape(double(red),1,rows*cols));
    St_Green=(reshape(double(green),1,rows*cols));
    St_Blue=(reshape(double(blue),1,rows*cols));
    
    St_BR=(St_Blue-St_Red)./(St_Blue+St_Red);

    HSV = rgb2hsv(InputImage);
    H_Image = HSV(:, :, 1);  % Extract the H image.
    S_Image = HSV(:, :, 2);  % Extract the S image.
    V_Image = HSV(:, :, 3);  % Extract the V image.
    St_H=reshape(H_Image,1,rows*cols);
    St_S=reshape(S_Image,1,rows*cols);
    St_V=reshape(V_Image,1,rows*cols);
    
    YIQ = rgb2ntsc(InputImage);
    Y=YIQ(:,:,1);
    I=YIQ(:,:,2);
    Q=YIQ(:,:,3);
    St_Y=double(reshape(Y,1,rows*cols));
    St_I=double(reshape(I,1,rows*cols));
    St_Q=double(reshape(Q,1,rows*cols));
       
    %Chroma array
    Chroma=zeros(1,rows*cols);
    ch_draft1=cat(1,St_Red,St_Green,St_Blue);
    for k=1:rows*cols
        Chroma(1,k)=max(ch_draft1(:,k))-min(ch_draft1(:,k));
    end

    rb1=St_Red./St_Blue;
    
    rb2=(St_Red-St_Blue);
    
    % Concatenated color channels considering all the images. This is required to find
    % the distribution of the individual channels
    R_cat=cat(2,R_cat,St_Red);
    G_cat=cat(2,G_cat,St_Green);
    B_cat=cat(2,B_cat,St_Blue);
    H_cat=cat(2,H_cat,St_H);
    S_cat=cat(2,S_cat,St_S);
    V_cat=cat(2,V_cat,St_V);
    Y_cat=cat(2,Y_cat,St_Y);
    I_cat=cat(2,I_cat,St_I);
    Q_cat=cat(2,Q_cat,St_Q);
    L_cat=cat(2,L_cat,St_L);
    a_cat=cat(2,a_cat,St_A);
    b_cat=cat(2,b_cat,St_B);    
    rb1_cat=cat(2,rb1_cat,rb1);
    rb2_cat=cat(2,rb2_cat,rb2);
    rb3_cat=cat(2,rb3_cat,St_BR);   
    C_cat=cat(2,C_cat,Chroma);
    
 end
% All images for-loop computation ends here


% The different statistical values are calculated here
R_5=prctile(R_cat,5);   R_95=prctile(R_cat,95); R_mean=mean(R_cat); R_std=std(R_cat);
G_5=prctile(G_cat,5);   G_95=prctile(G_cat,95); G_mean=mean(G_cat); G_std=std(G_cat);
B_5=prctile(B_cat,5);   B_95=prctile(B_cat,95); B_mean=mean(B_cat); B_std=std(B_cat);

H_5=prctile(H_cat,5);   H_95=prctile(H_cat,95); H_mean=mean(H_cat); H_std=std(H_cat);
S_5=prctile(S_cat,5);   S_95=prctile(S_cat,95); S_mean=mean(S_cat); S_std=std(S_cat);
V_5=prctile(V_cat,5);   V_95=prctile(V_cat,95); V_mean=mean(V_cat); V_std=std(V_cat);

Y_5=prctile(Y_cat,5);   Y_95=prctile(Y_cat,95); Y_mean=mean(Y_cat); Y_std=std(Y_cat);
I_5=prctile(I_cat,5);   I_95=prctile(I_cat,95); I_mean=mean(I_cat); I_std=std(I_cat);
Q_5=prctile(Q_cat,5);   Q_95=prctile(Q_cat,95); Q_mean=mean(Q_cat); Q_std=std(Q_cat);

L_5=prctile(L_cat,5);   L_95=prctile(L_cat,95); L_mean=mean(L_cat); L_std=std(L_cat);
a_5=prctile(a_cat,5);   a_95=prctile(a_cat,95); a_mean=mean(a_cat); a_std=std(a_cat);
b_5=prctile(b_cat,5);   b_95=prctile(b_cat,95); b_mean=mean(b_cat); b_std=std(b_cat);

rb1_5=prctile(rb1_cat,5);   rb1_95=prctile(rb1_cat,95); rb1_mean=mean(rb1_cat); rb1_std=std(rb1_cat);
rb2_5=prctile(rb2_cat,5);   rb2_95=prctile(rb2_cat,95); rb2_mean=mean(rb2_cat); rb2_std=std(rb2_cat);
rb3_5=prctile(rb3_cat,5);   rb3_95=prctile(rb3_cat,95); rb3_mean=mean(rb3_cat); rb3_std=std(rb3_cat);

C_5=prctile(C_cat,5);   C_95=prctile(C_cat,95); C_mean=mean(C_cat); C_std=std(C_cat);

% Save all the variables in the workspace.
save ('./precomputed/concatenated_image_statistical_values.mat');


