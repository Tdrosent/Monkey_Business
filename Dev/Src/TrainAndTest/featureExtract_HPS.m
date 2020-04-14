% feature exctraction
function featureExtract_HPS()

addpath('..\MatLabFiles')
dataPath = char('../../../Data/MasterTraining');
addpath(dataPath)

fs = 96000;
%CallNames = {'twitterCalls','pheeCalls','trillCalls'};
CallNames      = {'peep','peepString','phee','trill', 'tsik','tsikString','twitter'};
% I will send these files via email in case you guys need them
% CallNames      = {'DebugFile1','DebugFile2'};

windowSizeList = [ 0.02, 0.05, 0.1, 0.2, 1];

wlist = round(windowSizeList *fs);

mstimeList = windowSizeList * 10^3;

for j = 1:length(windowSizeList)
    TrainingFolderNameNotNormalized = strcat('../../../Data/Features/Training/HPS/NotNormalized',num2str(j));
    TrainingFolderNormalized = strcat('../../../Data/Features/Training/HPS/Normalized',num2str(j));
    
    %Need to clear matrix between each window size
    FullFeatures = [];

    %Create directories needed to place data
    if ~exist(TrainingFolderNameNotNormalized,'dir')
        mkdir(TrainingFolderNameNotNormalized);
    end
    
    if ~exist(TrainingFolderNormalized,'dir')
        mkdir(TrainingFolderNormalized);
    end
    
    %This is the main loop it will go through each call and extract all of
    %the HPS features. It will build up a large full data set to compute
    %the z-score.
    %On each pass it will save the features of each call in a
    %non-normalized .mat file that will be loaded in later and normalized
    for i = 1:length(CallNames)
        TrainFeatures = [];
        FileName = strcat(dataPath,'\',CallNames{i},'CallsTrainMaster.wav');
        %FileName = strcat(dataPath,'\',CallNames{i},'.wav');
        
        TrainwaveIn = audioread(FileName);
        
        TrainFeatures = HPSFeatures(TrainwaveIn,wlist(j),3);
        
        %Saving HPS results off as not normalized, we can read in these
        %features and normalize them after we run through everything.
        save(strcat(TrainingFolderNameNotNormalized,'/Features_','HPS_',num2str(mstimeList(j)),'ms_', CallNames{i}, 'Not_Normalized.mat'),'TrainFeatures')
        
        %Building up full feature set to compute normalization factors
        FullFeatures = [FullFeatures;TrainFeatures];
        
    end
    %Dynamically computing z-score Normalization factors
    mu = mean(FullFeatures);
    sigma = std(FullFeatures);
    NormalizationFactor.mu = mu;
    NormalizationFactor.sigma=sigma;
    
    %Saving Normalization factors in normalized folder
    save(strcat(TrainingFolderNormalized,'/Features_','HPS_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor')
    
    for i = 1:length(CallNames)
        CurrentMat = load(strcat(TrainingFolderNameNotNormalized,'/Features_','HPS_',num2str(mstimeList(j)),'ms_', CallNames{i}, 'Not_Normalized.mat'));
        CurrentFeatures = CurrentMat.TrainFeatures;
        %   normalize the data
        TrainNormFeatures = ((CurrentFeatures-mu))./sigma;
        save(strcat(TrainingFolderNormalized,'/Normalized_Features_','HPS_',num2str(mstimeList(j)),'ms_', CallNames{i}, '.mat'),'TrainNormFeatures')
    end
    
end



