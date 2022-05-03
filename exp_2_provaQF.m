image_dir = 'Dresden\natural\other_exp2';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)

FPR = 1e-6;
L=1024*1024;
T=sqrt(2/L)*erfcinv(2*FPR);

QF=[85, 65, 45, 25];

%INIZIALIZZIAMO I CONTATORI (SCALARI) DENTRO IL for,
%I VETTORI SERVONO SOLO PER SALVARE RISULTATO FINALE, SENZA DOVER 
%INIZIALIZZARE I VETTORI PER OGNI QF
correct_detection_tot=zeros(size(QF,2));
missed_detection_tot=zeros(size(QF,2));
false_alarm_tot=zeros(size(QF,2));

correct_detection_perc_qf=zeros(size(QF,2));
missed_detection_perc=zeros(size(QF,2));
false_alarm_perc=zeros(size(QF,2));

Im_f=zeros(1024,1024); %immagine nel dominio delle frequenze 
%inizializzo fuori per non rifarlo ogni volta, poi coefficienti
%sovrascritti

Ir_f=zeros(1024,1024); %immagine ricostruita, stesso discorso di Im_f
%Ciclo su immagini, indice k
    %scelta un'immagine: ciclo sui QF, indice qf
        %scelto un QF: ciclo su tutte le camere, indice i
            %FINITO CICLO SU TUTTE LE CAMERE SALVO IL RISULTATO
            %(correct/missed/false alarm) PER L'IMMAGINE CON UN CERTO QF
for k = 1:length(Im) %CICLO SULLE IMMAGINI DEL DATASET
    image_dir = 'Dresden\natural\other_exp2';
    Im = dir([image_dir,'\*.jpg']);
    addpath(image_dir);
    
    correct_detection=0;
    missed_detection=0;
    false_detection=0;

    conta_correct=0;
    conta_FA=0;
    %CALCOLO DEL JPEG DELL'IMMAGINE 
    Im=rgb2gray(Im);
    Im=double(Im); % original image - gray - double
    
    m=mean(mean(Im)); % mean value
    Im=Im-m*ones(1024,1024); % translated image

    for(qf=1:size(QF,2)) %CICLO SUI QF
        Q=jpeg_qtable(QF(qf));
        %CALCOLIAMO JPEG SOLO PER L'ANGOLO DA 1024x1024
        for r=1:8:1024
            for c=1:8:1024
                Im_f(r:(r+7),c:(c+7))=dct2(Im(r:(r+7),c:(c+7)));
                Q_image(r:(r+7),c:(c+7))=round(Im_f(r:(r+7),c:(c+7))./Q);
                Ir_f(r:(r+7),c:(c+7))=Q .* Q_image(r:(r+7),c:(c+7));
                Im_r(r:(r+7),c:(c+7))=idct2(Ir_f(r:(r+7),c:(c+7)));
            end
        end

        Im_r=Im_r+m*ones(1024,1024); %IMMAGINE RICOSTRUITA


        %IR DEVE ESSERE SALVATO TEMPORANEAMENTEPER ESSER DATO A
        %NOISEXTRACTFFROMIMAGE!!!!!
        Im_saved=imwrite(Im_r);
        
        for(i=1:10)% for each camera
            Noisex = NoiseExtractFromImageCrop(Im_saved,2, [1 1], [1024, 1024]);
            % % continue with your processing of k-th image
            % % you can save the result of processing (e.g., rho value) in a vector % with length(Im) elements
            Ix = double(rgb2gray(imread(Im_saved)));
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
            correct_detection_tot(qf)=correct_detection_tot(qf)+1;
        elseif(conta_FA==0 && conta_correct==0)
            missed_detection_tot(qf)=missed_detection_tot(qf)+1;
        elseif(conta_FA>0)
            false_detection_tot(qf)=false_detection_tot(qf)+1;
        end
    end


end
correct_detection_perc=correct_detection/100;
missed_detection_perc=missed_detection/100;
false_alarm_perc=false_alarm/100;