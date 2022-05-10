clc

% JPEG

image_dir = 'Dresden\natural\exp2';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)

T=input('insert the treshold T - choose 15 or 60\n');

QF=[85, 65, 45, 25]; % quality factor vector

correct_detection=zeros(1,size(QF,2));
missed_detection=zeros(1,size(QF,2));
false_detection=zeros(1,size(QF,2));

correct_detection_perc=zeros(1,size(QF,2));
missed_detection_perc=zeros(1,size(QF,2));
false_alarm_perc=zeros(1,size(QF,2));

L=1024*1024;
H1_count=zeros(1,size(QF,2)); H0_count=zeros(1,size(QF,2));

Im_f=zeros(1024,1024); %immagine nel dominio delle frequenze 
%inizializzo fuori per non rifarlo ogni volta, poi coefficienti
%sovrascritti

Ir_f=zeros(1024,1024); %immagine ricostruita, stesso discorso di Im_f
%Ciclo su immagini, indice k
    %scelta un'immagine: ciclo sui QF, indice qf
        %scelto un QF: ciclo su tutte le camere, indice i
            %FINITO CICLO SU TUTTE LE CAMERE SALVO IL RISULTATO
            %(correct/missed/false alarm) PER L'IMMAGINE CON UN CERTO QF
immagini_processate=0;


conta_correct=zeros(length(Im),size(QF,2));
conta_FA=zeros(length(Im),size(QF,2));
missed=zeros(length(Im),size(QF,2));
correct_non_detection=zeros(length(Im),size(QF,2));

for k = 1:length(Im)
    
    %CALCOLO DEL JPEG DELL'IMMAGINE 
    Im_c=rgb2gray(imread(Im(k).name));
    Im_c=Im_c(1:1024,1:1024);
    Im_c=double(Im_c); % original image - gray - double
    
    m=mean(mean(Im_c)); % mean value
    Im_c=Im_c-m*ones(1024,1024); % translated image
    for(qf=1:size(QF,2)) %CICLO SUI QF
        Q=jpeg_qtable(QF(qf));
        %CALCOLIAMO JPEG SOLO PER L'ANGOLO DA 1024x1024
        for r=1:8:1024
            for c=1:8:1024
                Im_f(r:(r+7),c:(c+7))=dct2(Im_c(r:(r+7),c:(c+7)));
                Q_image(r:(r+7),c:(c+7))=round(Im_f(r:(r+7),c:(c+7))./Q);
                Ir_f(r:(r+7),c:(c+7))=Q .* Q_image(r:(r+7),c:(c+7));
                Im_r(r:(r+7),c:(c+7))=idct2(Ir_f(r:(r+7),c:(c+7)));
            end
        end

        Im_r=Im_r+m*ones(1024,1024); %IMMAGINE RICOSTRUITA


        %IR DEVE ESSERE SALVATO TEMPORANEAMENTEPER ESSER DATO A
        %NOISEXTRACTFFROMIMAGE!!!!!

        
        %         Im_saved=imwrite(Im_r);  !!!   
        
    
    Noisex = NoiseExtractFromImageCrop(Im_r,2, [1 1], [1024, 1024]);
    
    Ix = Im_r;
    
    for(i=1:10)% for each camera

    % % normalized correlation (value of normalized correlation between Noisex and Ix.*RP will be contained in rho)
    C = crosscorr(Noisex, Ix(1:1024,1:1024).*PRNU_1024x1024(i).fingerprint);
    Out = PCE(C);
    PCEmetric = Out.PCE;
     
    if(10*(i-1)<k && k<=10*i) % H1
        H1_count(qf)=H1_count(qf)+1;
        if((PCEmetric)>T) % decido H1 -> corretta
            conta_correct(k,qf)=conta_correct(k,qf)+1;
        else % decido H0 -> sbagliato
            missed(k,qf)=missed(k,qf)+1;
        end
    
    else                      % H0
        H0_count(qf)=H0_count(qf)+1;
        if((PCEmetric)>T) % decido H1 -> sbagliato
            conta_FA(k,qf)=conta_FA(k,qf)+1;
        end
    end
    
 end
    
    if(conta_correct(k,qf)==1 && conta_FA(k,qf)==0)
        correct_detection(qf)=correct_detection(qf)+1;
    elseif(conta_FA(k,qf)==0 && conta_correct(k,qf)==0)
        missed_detection(qf)=missed_detection(qf)+1;
    elseif(conta_FA(k,qf)>0)
        false_detection(qf)=false_detection(qf)+1;
    end
    
    immagini_processate=immagini_processate+1
    end
end

% Given a image k:

% we define a correct_detection if the algorithm
% select ONLY the correct camera.

% we define a missed_detection if the algorithm does not select any camera

% we define a false_detection if the algorithm select at least a wrong
% camera



% Ora per verificare che la soglia calcolata con erfcinv sia davvero funzione di fpr, calcoliamo:

FPR_simulated=zeros(1,size(QF,2));
DR_simulated=FPR_simulated;
FNR_simulated=FPR_simulated;

 for qf=1:size(QF,2)
   
   correct_detection_perc(qf)=correct_detection(qf)/length(Im);
   missed_detection_perc(qf)=missed_detection(qf)/length(Im);
   false_alarm_perc(qf)=false_detection(qf)/length(Im);  
     
   FPR_simulated(qf) = sum(conta_FA(:,qf))/(H0_count(qf)); %probabilità di falso allarme (decido H1 quando è H0)
   DR_simulated(qf) = sum(conta_correct(:,qf))/(H1_count(qf));%probabilità di decisione corretta di H1
   FNR_simulated(qf) = sum(missed(:,qf))/(H1_count(qf)); %probabilità di decidere erroneamente H0
 end

%questa non è importante:
%P_correct_non_detection=sum(correct_non_detection)/(H0_count); %probabilità di decidere correttamente H0