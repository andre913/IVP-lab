% resize

clc

resize_factor=[1.25,0.5,0.25];

PRNU_resized_enlarge=PRNU_1024x1024;
PRNU_resized_medium=PRNU_1024x1024;
PRNU_resized_quarter=PRNU_1024x1024;

for i=1:10
PRNU_resized_enlarge(i).fingerprint=imresize(PRNU_1024x1024(i).fingerprint,1.25);
PRNU_resized_medium(i).fingerprint=imresize(PRNU_1024x1024(i).fingerprint,0.5);
PRNU_resized_quarter(i).fingerprint=imresize(PRNU_1024x1024(i).fingerprint,0.25);
end


RF=size(resize_factor,2);


image_dir = 'Dresden\natural\exp2';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir);

%FPR = 1e-6;
FPR=1e-6;
L=1024*1024;
T=sqrt(2/L)*erfcinv(2*FPR); %decision treshold
H1_count=zeros(1,RF); H0_count=zeros(1,RF);

correct_detection=zeros(1,RF);
missed_detection=zeros(1,RF);
false_detection=zeros(1,RF);


immagini_processate=0;
  
conta_correct=zeros(length(Im),RF);
conta_FA=zeros(length(Im),RF);
missed=zeros(length(Im),RF);
correct_non_detection=zeros(length(Im),RF);

for rf=1:RF % for each resize factor


for k = 1:length(Im)
    
    act_im=imread(Im(k).name);
    act_im=rgb2gray(act_im);
    act_im=double(act_im);
    
   
    Im_r=imresize(act_im(1:1024, 1:1024),resize_factor(rf));
    
    Noisex = NoiseExtractFromImage(Im_r,2);
    Ix = Im_r;
    
    for(i=1:10)% for each camera

    % % normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
     C = corrcoef(Noisex, Ix.*imresize(PRNU_1024x1024(i).fingerprint,resize_factor(rf)));
     rho_camera = C(1,2);
     
    if(10*(i-1)<k && k<=10*i) % H1
        H1_count(rf)=H1_count(rf)+1;
        if((rho_camera)>T) % decido H1 -> corretta
            conta_correct(k,rf)=conta_correct(k,rf)+1;
        else % decido H0 -> sbagliato
            missed(k,rf)=missed(k,rf)+1;
        end
    
    else                      % H0
        H0_count(rf)=H0_count(rf)+1;
        if((rho_camera)>T) % decido H1 -> sbagliato
            conta_FA(k,rf)=conta_FA(k,rf)+1;
        end
    end
    
 end
    
    if(conta_correct(k,rf)==1 && conta_FA(k,rf)==0)
        correct_detection(rf)=correct_detection(rf)+1;
    elseif(conta_FA(k,rf)==0 && conta_correct(k,rf)==0)
        missed_detection(rf)=missed_detection(rf)+1;
    elseif(conta_FA(k,rf)>0)
        false_detection(rf)=false_detection(rf)+1;
    end
    
    immagini_processate=immagini_processate+1
end

% Given a image k:

% we define a correct_detection if the algorithm
% select ONLY the correct camera.

% we define a missed_detection if the algorithm does not select any camera

% we define a false_detection if the algorithm select at least a wrong
% camera

end

for rf=1:RF
correct_perc(rf)=correct_detection(rf)/length(Im);
missed_detection_perc(rf)=missed_detection(rf)/length(Im);
false_alarm_perc(rf)=false_detection(rf)/length(Im);


% Ora per verificare che la soglia calcolata con erfcinv sia davvero funzione di fpr, calcoliamo:

FPR_simulated(rf) = sum(conta_FA(:,rf))/(H0_count(rf)); %probabilità di falso allarme (decido H1 quando è H0)
DR_simulated(rf) = sum(conta_correct(:,rf))/(H1_count(rf));%probabilità di decisione corretta di H1
FNR_simulated(rf) = sum(missed(:,rf))/(H1_count(rf)); %probabilità di decidere erroneamente H0

end
%questa non è importante:
%P_correct_non_detection=sum(correct_non_detection)/(H0_count); %probabilità di decidere correttamente H0

