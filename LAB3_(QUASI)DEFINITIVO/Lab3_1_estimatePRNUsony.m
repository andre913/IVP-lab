clc

% LAB3_1

%%%%% RP estimation from flatfield pictures %%%%

% read all JPEG images in a folder

% we choose the sony camera
image_dir = 'Dresden\flatfield\Sony_DSC-W170_1';
Im = dir([image_dir,'\*.jpg']);

%estimate fingerprint (3 channels)
addpath(image_dir)
RP = getFingerprintCrop(Im, [1 1], [1024 1024]);

% obtain actual PRNU
RP = rgb2gray1(RP);

