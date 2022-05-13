%LAB 3_1

%cambiamo minibatch size a 50

clc
clear

imageSize=28*28;

digitDatasetPath=fullfile(matlabroot,'toolbox','nnet','nndemos','nndatasets','DigitDataset');
%save path

imds = imageDatastore(digitDatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');

[TrainingSet,ValidationSet]=splitEachLabel(imds,0.75,'randomized');

% Network

inputLayer=imageInputLayer([28 28]);
L1=fullyConnectedLayer(100);
L2=fullyConnectedLayer(100);
L3=fullyConnectedLayer(10); % last layer

myNet=[inputLayer L1 reluLayer L2 reluLayer L3 softmaxLayer classificationLayer];

options = trainingOptions('sgdm','MiniBatchSize',50,'InitialLearnRate',0.001,'MaxEpochs',30,'ValidationPatience',Inf);

trainedNet = trainNetwork(imds,myNet,options);

YPred = classify(trainedNet, ValidationSet);

%1 evaluate accuracy
Accuracy=size(find(YPred==ValidationSet.Labels),1)/size(ValidationSet.Labels,1)

%2 loss during training -> SCREEN

%3 scegli una immagine --> ... le becca tutte XD









% suggerimento: fare grafico YPred vs MaxEpoch se avanza tempo
