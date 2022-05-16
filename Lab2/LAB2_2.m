clc
clear
close all

% sistemato DA andrea migliorati king dei lab

clear
close all

O=imread('lena512color.tiff');

GO=rgb2gray(O);

GO=double(GO);
imshow(uint8(GO));
title('original');

bpp_vec=zeros(1, 7);
PSNR_vec=zeros(1,7);

alpha=1;
%range=[-256,256]; % MyQuant range
range=[-100,100]; % MyQuant range


for(k=1:8)
    lev=2^k; % quantization level -> we try 2 4 8 16 32 64 128 256
    
    % INITIALIZATION
    Xp=zeros(size(GO,1),size(GO,2)-1); %predicted image
    e=zeros(size(GO,1),size(GO,2)-1); %error
    e_hat=zeros(size(GO,1),size(GO,2)-1); % Error after myQuant
    x_hat=zeros(size(GO,1), size(GO,2)); %reconstructed image
    
    x_hat(:,1)=GO(:,1); %prima colonna della reconstructed è uguale all'originale
    
    for j=2:size(GO,2) %ciclo su colonne
        
        Xp(:,j-1)=alpha*x_hat(:,j-1);
        
       %e(:,j-1)=GO(:,j-1)-Xp(:,j-1);
        e(:,j-1)=GO(:,j)-Xp(:,j-1);
        
        e_hat(:,j-1)=myQuant(e(:,j-1),lev,range);
        
        x_hat(:,j)=Xp(:,j-1)+e_hat(:,j-1);
    end
    
    % figure;
    % imshow(uint8(e))
    % title_name=sprintf('prediction error image alpha=%f - levels=%d', alpha, lev);
    % title(title_name);
    
    e_freq=unique(e_hat); %lista dei valori degli errori dopo myQuant
    
    e_prob=zeros(size(e_freq,1),1); % vettore probabilità di ogni errore
    
    for i=1:size(e_freq,1)
        e_prob(i)=sum(e_hat(:)== e_freq(i))/((size(e_hat,1)*size(e_hat,2))); %calcolo probabilità di ciascun errore
    end
    
    
    %togliere i commenti per vedere confronto istogramma errori ed errori dopo
    %myQuant
    
    
    % figure;
    % histogram(e)
    % title_name=sprintf('errors hist - alfa = %f - levels=%d',alpha,lev);
    % title(title_name);
    
    % figure;
    % histogram(e_hat)
    % title_name=sprintf('quantized errors hist - alfa = %f - levels=%d',alpha,lev);
    % title(title_name);
    
    
    DICT=huffmandict(e_freq,e_prob); %crea un dizionario da Huffman coding - con codici più lunghi per gli errori meno probabili
    
    e_c=huffmanenco(e_hat(:),DICT); % sequenza di bit che codifica e, da inviare a RX
    
    %DECODING
    %ricevitore riceve prima colonna dell'immagine originale e gli errori
    %codificati
    
    e_hat_deco=huffmandeco(e_c,DICT);
    e_hat_r=reshape(e_hat_deco, size(GO,1), size(GO,2)-1); % per riportare su dimensione 512x511
    
    Xp_r=zeros(size(GO,1), size(GO,2)-1);
    x_hat_r=zeros(size(GO,1), size(GO,2));
    
    x_hat_r(:,1)=GO(:,1); %prima colonna dell'immagine originale è nota
    for(j=2:512) %ciclo su colonne
        
        Xp_r(:,j-1)=alpha*x_hat_r(:,j-1);
        
        x_hat_r(:,j)=Xp_r(:,j-1)+e_hat_r(:,j-1);
    end
    
    figure;
    imshow(uint8(x_hat_r))
    title_name=sprintf('reconstructed image - MyQuant level=%d -alpha=%d',lev,alpha);
    title(title_name);
    
    bpp_vec(k)=numel(e_c)/(512*511);
    %PSNR_vec(k)=psnr(uint8(x_hat_r),uint8(GO));
    PSNR_vec(k)=psnr(x_hat_r,GO,256);
    
end

bpp_vec
PSNR_vec

figure;
plot(bpp_vec, PSNR_vec,'o-','LineWidth',1.9)
grid on;
xlabel('bpp'),ylabel('PSNR');

