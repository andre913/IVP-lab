image_dir = 'Dresden\natural\other_exp2';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)

FPR = 1e-6;
L=1024*1024;
T=sqrt(2/L)*erfcinv(2*FPR);

correct_detection=0;
missed_detection=0;
false_detection=0;

perc_correct_perc=0;
missed_detection_perc=0;
false_alarm_perc=0;

for k = 1:length(Im)
    conta_correct=0;
    conta_FA=0;
    for(i=1:10)% for each camera

 Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);
% % continue with your processing of k-th image
% % you can save the result of processing (e.g., rho value) in a vector % with length(Im) elements
 Ix = double(rgb2gray(imread(Im(k).name)));
% % normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
 C = corrcoef(Noisex, Ix(1:1024,1:1024).*PRNU_1024x1024(i).fingerprint);
 rho_camera = C(1,2);
 
 if((rho_camera)>T)
     
     if(10*(i-1)<k<=10*i)
         conta_correct=conta_correct+1;
     else
         conta_FA=conta_FA+1;
     end
 end


 

    end

    if(conta_correct==1 )%&& conta_FA(k)==0)
        correct_detection=correct_detection+1;
    elseif(conta_FA==0 && conta_correct==0)
        missed_detection=missed_detection+1;
    elseif(conta_FA>0)
        false_detection=false_detection+1;
    end
end
perc_correct_perc=correct_detection/100;
missed_detection_perc=missed_detection/100;
false_alarm_perc=false_alarm/100;