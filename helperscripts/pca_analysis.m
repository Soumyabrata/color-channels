function pca_analysis
% This script generates the statistical values of concatenated
% distribution.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------


% This part does all the analysis on the PCA of color channels. All the
% figures in the paper can be obtained from the following code snipset.



%find_statistical_values_conc_image;   % HYTA datset should be present to run this statement.
% Uncomment the above line if the following .mat file is already present.
load concatenated_image_statistical_values.mat ;    % Pre-computed value for reproducibility.


Files=dir('./HYTA+GT/images/*.jpg');
NoOfImages=size(Files);
SumArray=zeros(16,1);
pca_matrix=zeros(16,NoOfImages(1));
oned_rank_matrix=zeros(16,NoOfImages(1));
oned_length_matrix=zeros(16,NoOfImages(1));
PBI_matrix=zeros(16,NoOfImages(1));
oned_p1_matrix=zeros(16,NoOfImages(1));
ninety_rank_vector=zeros(16,1);
ten_rank_vector=zeros(16,1);
min_rank_vector=zeros(16,1);
max_rank_vector=zeros(16,1);
avg_rank_vector=zeros(16,1);
avg_length_vector=zeros(16,1);
ws=cell(5);
ws2=cell(5);


for kot=1:length(Files)   
    
    FileNames=Files(kot).name;
    InputImage=imread(['./HYTA+GT/images/',FileNames]);
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

    % This normalisation is based on the Normal distribution fundamentals
    R_norm=(St_Red-R_mean)/(R_std);
    G_norm=(St_Green-G_mean)/(G_std);
    B_norm=(St_Blue-B_mean)/(B_std);
    
    H_norm=(St_H-H_mean)/(H_std);
    S_norm=(St_S-S_mean)/(S_std);
    V_norm=(St_V-V_mean)/(V_std);
    
    Y_norm=(St_Y-Y_mean)/(Y_std);
    I_norm=(St_I-I_mean)/(I_std);
    Q_norm=(St_Q-Q_mean)/(Q_std);
    
    L_norm=(St_L-L_mean)/(L_std);
    a_norm=(St_A-a_mean)/(a_std);
    b_norm=(St_B-b_mean)/(b_std);
    
    rb1_norm=(rb1-rb1_mean)/(rb1_std);
    rb2_norm=(rb2-rb2_mean)/(rb2_std);
    rb3_norm=(St_BR-rb3_mean)/(rb3_std);    
    
    C_norm=(Chroma-C_mean)/(C_std);
         
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
    
%     Re-projecting the data points
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
    
    
    % Populating the pca_matrix matrix
    for t=1:16
        pca_matrix(t,kot)=explained(t);
    end
    Dist_measure2=p1.*p1+p2.*p2;
    Dist_measure=sqrt(Dist_measure2);
     
    [~, ~, forwardRank] = unique(Dist_measure); % Unique sorts in ascending order
    Rank_vector = max(forwardRank) - forwardRank  + 1; % Higher lengths will have lower ranks.
    
    
    % 2 D ranking
    bi_input=cat(2,p1,p2);
    Obs_labels={'Red','Green','Blue','Hue','Sat','Val','YIQ_Y','YIQ_I','YIQ_Q','LAB_L','LAB_A','LAB_B','rb1','rb2','rb3','Chroma'};
    [arx,ary,arx_2D,ary_2D] = biplot_modified(bi_input,'VarLabels',Obs_labels);
    close gcf;
    points_of_biplot=cat(2,arx(2,:)',ary(2,:)');
    
    sin_theta_matrix=zeros(16,16);
    area_matrix=zeros(16,16);
    
    inner_loop_count=1;
    for j=1:16
        a1=points_of_biplot(j,:);
        k=inner_loop_count;
        while(k<17)
            a2=points_of_biplot(k,:);
            
            l1=norm(a1);
            l2=norm(a2);
            
            CosTheta = dot(a1,a2)/(norm(a1)*norm(a2));
            SinTheta=sqrt(1-power(CosTheta,2));
            sin_theta_matrix(j,k)=SinTheta; % populating sin theta matrix
            sin_theta_matrix(k,j)=SinTheta; % populating the symmetrical entries
            
            area=(l1*l2*SinTheta)/2;
            area_matrix(j,k)=area;
            area_matrix(k,j)=area;
            
            k=k+1;
        end
        inner_loop_count=inner_loop_count+1;
    end
    
   area_vector=reshape(area_matrix,1,16*16); 
   
   ws2{kot}=abs(CovMat);
    
end
% All images for-loop computation ends here






% Save all the variables in the workspace.
save ('./precomputed/pca_analysis_variables.mat');


