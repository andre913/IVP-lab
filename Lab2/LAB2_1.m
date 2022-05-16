clc
clear
close all

O=imread('lena512color.tiff');

GO=rgb2gray(O);

GO=double(GO);
imshow(uint8(GO));
title('original');

Xp=zeros(size(GO,1),size(GO,2)-1); %predicted image
e=zeros(size(GO,1),size(GO,2)-1); %error

alpha=[0.5, 1.0, 2.0];
for(a=1:size(alpha,2))
        for(j=1:size(GO,2)-1) %ciclo su colonne, escludo l'ultima perchè nuova img ha colonna in meno
            Xp(:,j)=alpha(a)*GO(:,j); %abbiamo "predetto" tutte le colonne eccetuata l'ultima. In questo modo pred_img ha una colonna in meno
        end
    e=Xp-GO(:,2:512);  %remove final column to match dimension (we didn't use it)
   % figure;

    
    figure;
    histogram(GO)
    title_name=sprintf('histogram original image greyscale - alpha = %.1f',alpha(a));
    title(title_name);
       
    figure;
    histogram(e)
    title_name=sprintf('histogram predicted error image - alpha = %.1f',alpha(a));    %osserviamo che con ALPHA=1 il picco è in zero ad indicare che quasi tutti i pixels sono simili
    title(title_name);
    %con alpha=0.5 e 2 gli istogrammi sono specchiati e riscalati
    
end