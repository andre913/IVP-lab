clc

image_dir = 'Dresden\natural\challenge';
Im = dir([image_dir,'\*.jpg']);
addpath(image_dir)

FPR=1e-6;
L=1024*1024;

% T: SOGLIA PCE DECISION -> DA STABILIRE !!!!!!!!!!!!!!!

for k = 1:length(Im)
    Image = imread(Im(k).name);
    
      if(size(Image,1) < 1024 || size(Image,2) < 1024)
          Image=imresize(Image,1024/min(size(Image,1),size(Image,2)));
     end
    
    imwrite(Image,Im(k).name)
    
    Noisex = NoiseExtractFromImageCrop(Im(k).name,2, [1 1], [1024, 1024]);
    Ix = double(rgb2gray(imread(Im(k).name)));
    
    max=0;
    
    for i=1:10 % for each PRNU
       
       C = crosscorr(Noisex, Ix(1:1024,1:1024).*PRNU_1024x1024(i).fingerprint);
       Out = PCE(C);
       metric=Out.PCE;
       
       if (metric>max)
           max=metric;
           ipos=i; %save the prnu associated to the maximum correlation
       end
    end
    
    %if(max>T) % SOGLIA DA STABILIRE !!!!!!!!!!!!!!!!
      string=PRNU_1024x1024(ipos).camera;
    %else
      %  string=sprintf('unknow'); % nessuna camera detectata
   % end
    
      result=sprintf('\nPicture %s is taken by %s camera\n',Im(k).name,string);
      fprintf(result);
 end
    
