clc

% LAB3_2

%%%%%%%%%% noise extraction and correlation with PR for sony camera
%%%%%%%%%% picture and others %%%%%%%

image_dir = 'Dresden\natural\sony50';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)
 for k = 1:length(Im) %estrazione noise dalle 50 foto natural - sony
 Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);

 Ix = double(rgb2gray(imread(Im(k).name)));
 
% normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
 C = corrcoef(Noisex, Ix(1:1024,1:1024).*RP);
 rho_sony(k) = C(1,2);
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
 end

mean_sony=mean(rho_sony);
var_sony=var(rho_sony);

mean_other=mean(rho_other);
var_other=var(rho_other);

figure;
histogram(rho_sony)
hold on
histogram(rho_other)
legend('sony histogram','other histogram');
title('Correlation histogram - sony pictures vs others');

% possible treshold:
%(mean_sony+mean_other)/2;