clc

image_dir = 'Dresden\natural\exp2';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)

FPR=1e-6;
L=1024*1024;

T=input('insert the treshold T - choose 15 or 60\n');
H1_count=0; H0_count=0;

correct_detection=0;
missed_detection=0;
false_detection=0;


immagini_processate=0;

for k = 1:length(Im)
    conta_correct(k)=0;
    conta_FA(k)=0;
    missed(k)=0;
    correct_non_detection(k)=0;
    
    
    
    Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);
    Ix = double(rgb2gray(imread(Im(k).name)));
    
    for(i=1:10)% for each camera

    % % normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
    
     C = crosscorr(Noisex, Ix(1:1024,1:1024).*PRNU_1024x1024(i).fingerprint);
     Out = PCE(C);
     PCEmetric = Out.PCE;
     
    if(10*(i-1)<k && k<=10*i) % H1
        H1_count=H1_count+1;
        if((PCEmetric)>T) % decido H1 -> corretta
            conta_correct(k)=conta_correct(k)+1;
        else % decido H0 -> sbagliato
            missed(k)=missed(k)+1;
        end
    
    else                      % H0
        H0_count=H0_count+1;
        if((PCEmetric)>T) % decido H1 -> sbagliato
            conta_FA(k)=conta_FA(k)+1;
        end
    end
    
 end
    
    if(conta_correct(k)==1 && conta_FA(k)==0)
        correct_detection=correct_detection+1;
    elseif(conta_FA(k)==0 && conta_correct(k)==0)
        missed_detection=missed_detection+1;
    elseif(conta_FA(k)>0)
        false_detection=false_detection+1;
    end
    
    immagini_processate=immagini_processate+1
end

% Given a image k:

% we define a correct_detection if the algorithm
% select ONLY the correct camera.

% we define a missed_detection if the algorithm does not select any camera

% we define a false_detection if the algorithm select at least a wrong
% camera
correct_perc=correct_detection/length(Im);
missed_detection_perc=missed_detection/length(Im);
false_alarm_perc=false_detection/length(Im);


% Ora per verificare che la soglia calcolata con erfcinv sia davvero funzione di fpr, calcoliamo:

FPR_simulated = sum(conta_FA)/(H0_count) %probabilità di falso allarme (decido H1 quando è H0)
DR_simulated = sum(conta_correct)/(H1_count)%probabilità di decisione corretta di H1
FNR_simulated = sum(missed)/(H1_count) %probabilità di decidere erroneamente H0

%questa non è importante:
%P_correct_non_detection=sum(correct_non_detection)/(H0_count); %probabilità di decidere correttamente H0


