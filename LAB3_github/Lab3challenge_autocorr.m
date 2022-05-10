clc

image_dir = 'Dresden\natural\challenge';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)

FPR=1e-6;
L=1024*1024;
T=sqrt(2/L)*erfcinv(2*FPR); %decision treshold

rhocamera=zeros(length(Im),10);

for k = 1:length(Im)
    Image = imread(Im(k).name);
    
      if(size(Image,1) < 1024 || size(Image,2) < 1024) % se minore di 1024x1024 dà problemi
           Image=imresize(Image,1024/min(size(Image,1),size(Image,2)));
      end
     
    imwrite(Image,Im(k).name)
    
    Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);
    Ix = double(rgb2gray(imread(Im(k).name)));
    
    max=0;
    
    for i=1:10 % for each PRNU
       C = corrcoef(Noisex, Ix(1:1024,1:1024).*PRNU_1024x1024(i).fingerprint);
       rho_camera(k,i) = C(1,2);
       
       if (rho_camera(k,i)>max)
           max=rho_camera(k,i);
           ipos=i; %save the prnu associated to the maximum correlation
       end
    end
    
    if(max>T)
      string=PRNU_1024x1024(ipos).camera;
    else
        string=sprintf('unknow'); % nessuna camera detectata
    end
    
      result=sprintf('\nPicture %s is taken by %s camera\n',Im(k).name,string);
      fprintf(result);
 end
    

    
    
    