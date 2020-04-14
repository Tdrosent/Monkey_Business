% feature exctraction
function featureExtract_HPS()

addpath('..\MatLabFiles')
dataPath = char('../../../Data/MasterTraining');
addpath(dataPath)

fs = 96000;
%CallNames = {'twitterCalls','pheeCalls','trillCalls'};
CallNames      = {'peep','peepString','phee','trill', 'tsik','tsikString','twitter'};


FullFeatures = [];

windowSizeList = [ 0.02, 0.05, 0.1, 0.2, 1];

wlist = round(windowSizeList *fs);

mstimeList = windowSizeList * 10^3;

for j = 1:length(windowSizeList)
    TrainingFolderName = strcat('../../../Data/Features/Training/HPS',num2str(j));
    
    %First extract the features from the Full Data, Z-Score
    %normailization must be done on all of the data not on a call by
    %call basis
    
    %Dynamically computing z-score Normalization factors
    
    
    if ~exist(TrainingFolderName,'dir')
        mkdir(TrainingFolderName);
    end
    
    for i = 1:length(CallNames)
        
        FileName = strcat(dataPath,'\',CallNames{i},'CallsTrainMaster.wav');
        
        TrainwaveIn = audioread(FileName);
        
        TrainFeatures{:,:,i} = HPSFeatures(TrainwaveIn,wlist(j),3);
        
        currentFeature =  TrainFeatures(:,i);
        
        save(strcat(TrainingFolderName,'/Features_','HPS_',num2str(mstimeList(j)),'ms_', CallNames{i}, '.mat'),'currentFeature')
        
        FullFeatures = [FullFeatures;TrainFeatures{:,:,i}];
        
    end
    mu = mean(FullFeatures);
    sigma = std(FullFeatures);
    NormalizationFactor.mu = mu;
    NormalizationFactor.sigma=sigma;
    
    %   normalize the data
    TrainNormFeatures = ((TrainFeatures-mu))./sigma;
    
    save(strcat(TrainingFolderName,'/Features_','HPS_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor')
    for i = 1:length(CallNames)
        
        currentFeature =  TrainFeatures{:,:,i};
        
        save(strcat(TrainingFolderName,'/Normalized_Features_','HPS_',num2str(mstimeList(j)),'ms_', CallNames{i}, '.mat'),'currentFeature')
    end
end



