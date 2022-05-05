clc

% LAB3_1_W

%%%%% RP estimation from flatfield pictures - Wiener filter %%%%

% read all JPEG images in a folder

% we choose the sony camera
image_dir = 'Dresden\flatfield\Sony_DSC-W170_1';
Im = dir([image_dir,'\*.jpg']);
% estimate fingerprint (3 channels)
addpath(image_dir)
RP_W = getFingerprintCrop(Im, [1 1], [1024 1024]);
% obtain actual PRNU
RP_W = rgb2gray1(RP_W);
% optional: uncomment the following two lines to remove periodic artifacts through Wiener filtering of DFT
 sigmaRP = std2(RP_W);
 Fingerprint = WienerInDFT(RP_W,sigmaRP);
