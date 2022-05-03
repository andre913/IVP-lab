% read all JPEG images in a folder
image_dir = 'Dresden\flatfield\Sony_DSC-W170_1';
Im = dir([image_dir,'\*.jpg']);
% estimate fingerprint (3 channels)
addpath(image_dir)
RP = getFingerprintCrop(Im, [1 1], [1024 1024]);
% obtain actual PRNU
RP = rgb2gray1(RP);
% optional: uncomment the following two lines to remove periodic artifacts through Wiener filtering of DFT
 sigmaRP = std2(RP);
 Fingerprint = WienerInDFT(RP,sigmaRP);
