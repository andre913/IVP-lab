clc

% LAB3_2

%%%%%%%%%% noise extraction and correlation with PR for sony camera
%%%%%%%%%% picture and others %%%%%%%

image_dir = 'Dresden\natural\sony50';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)

immagini_processate=0;

 for k = 1:length(Im) %estrazione noise dalle 50 foto natural - sony
 Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);

 Ix = double(rgb2gray(imread(Im(k).name)));
 
% normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
 C = corrcoef(Noisex, Ix(1:1024,1:1024).*RP);
 rho_sony(k) = C(1,2);
 
 C = crosscorr(Noisex, Ix(1:1024,1:1024).*RP);
 Out = PCE(C);
 metric_sony(k) = Out.PCE;
 
 immagini_processate=immagini_processate+1

 end
 
image_dir = 'Dresden\natural\other50';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)
 for k = 1:length(Im) %estrazione noise dalle 50 foto natural - other cameras
 Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);

 Ix = double(rgb2gray(imread(Im(k).name)));

 % normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
 C = corrcoef(Noisex, Ix(1:1024,1:1024).*RP);
 rho_other(k) = C(1,2);
 
 C = crosscorr(Noisex, Ix(1:1024,1:1024).*RP);
 Out = PCE(C);
 metric_other(k) = Out.PCE;
 
 immagini_processate=immagini_processate+1
 end

mean_sony=mean(rho_sony);
var_sony=var(rho_sony);

mean_other=mean(rho_other);
var_other=var(rho_other);






mean_sony_PCE=mean(metric_sony);
var_sony_PCE=var(metric_sony);

mean_other_PCE=mean(metric_other);
var_other_PCE=var(metric_other);


figure;
histogram(metric_sony,'FaceColor','r')
hold on
histogram(metric_other,'FaceColor','b')
legend('sony','others');
title('PCE histogram - sony pictures vs others');
grid on;

% possible tresholds T:

%T=(mean_sony+mean_other)/2;

%decision treshold according to the FPR
% FPR=1e-6;
% T=sqrt(2/L)*erfcinv(2*FPR); 

figure;
histogram(rho_sony,'FaceColor','r')
hold on
histogram(rho_other,'FaceColor','b')
legend('sony','others');
title('Normalized correlation histogram - sony pictures vs others');
grid on;


