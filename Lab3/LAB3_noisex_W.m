%Processing all *.jpg images in a folder
%Sony_DSC-W170_1

rho_sony_w=zeros(1,50);
rho_other_w=zeros(1,50);
image_dir = 'Dresden\natural\sony50';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)
 for k = 1:length(Im) %estrazione noise dalle 50 foto naturali sony
 Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);
 Noisex = WienerInDFT(Noisex,std2(Noisex));
% % continue with your processing of k-th image
% % you can save the result of processing (e.g., rho value) in a vector % with length(Im) elements
 Ix = double(rgb2gray(imread(Im(k).name)));
% % normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
 C = corrcoef(Noisex, Ix(1:1024,1:1024).*RP);
 rho_sony_w(k) = C(1,2);
 end
image_dir = 'Dresden\natural\other';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)
 for k = 1:length(Im) %estrazione noise dalle 50 foto naturali delle altre camere 
 Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);
 Noisex = WienerInDFT(Noisex,std2(Noisex));
% % continue with your processing of k-th image
% % you can save the result of processing (e.g., rho value) in a vector % with length(Im) elements
 Ix = double(rgb2gray(imread(Im(k).name)));
% % normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
 C = corrcoef(Noisex, Ix(1:1024,1:1024).*RP);
 rho_other_w(k) = C(1,2);
 end

mean_sony_w=mean(rho_sony_w);
var_sony_w=var(rho_sony_w);

mean_other_w=mean(rho_other_w);
var_other_w=var(rho_other_w);

figure;
histogram(rho_sony_w)
hold on
histogram(rho_other_w)


%CALCOLARE SOGLIA DECISIONE!!
