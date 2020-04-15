% feature exctraction
function featureExtract_HNR()
dataPathTrain = char('../../../Data/MasterTraining');
dataPathTest = char('../../../Data/MasterTesting');
addpath(dataPathTrain)
addpath(dataPathTest)

fs = 96000;
CallNames      = {'peep','peepString','phee','trill', 'tsik','tsikString','twitter'};
% CallNames      = {'DebugFile1','DebugFile2'};

windowSizeList = [ 0.02, 0.05, 0.1, 0.2, 1];
wlist = round(windowSizeList *fs);
mstimeList = windowSizeList * 10^3;


for j = 1:length(windowSizeList)
    TrainingFolderName = strcat('../../../Data/Features/Training/HNR',num2str(j));
    TestingFolderName  = strcat('../../../Data/Features/Testing/HNR',num2str(j));
    FullFeatures=[];
    if ~exist(TrainingFolderName,'dir')
        mkdir(TrainingFolderName);
    end
    if ~exist(TestingFolderName,'dir')
        mkdir(TestingFolderName);
    end
    hnrWndw = hamming(wlist(j));
    
    for i = 1:length(CallNames)
        TrainFeatures = [];
        FileName = strcat(dataPathTrain,'\',CallNames{i},'CallsTrainMaster.wav');
        
        TrainwaveIn = audioread(FileName);
        
        TrainFeatures = harmonicRatio(TrainwaveIn,fs,'Window',hnrWndw,'OverlapLength',wlist(j)/2);
        
        %Building up full feature set to compute normalization factors
        FullFeatures = [FullFeatures;TrainFeatures];
        
    end        

    
    %Dynamically computing z-score Normalization factors
    mu = mean(FullFeatures);
    sigma = std(FullFeatures);
    NormalizationFactor.mu = mu;
    NormalizationFactor.sigma=sigma;

    save(strcat(TrainingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor')
    for i = 1:length(CallNames)
        
        FileNameTrain = strcat(dataPathTrain,'\',CallNames{i},'CallsTrainMaster.wav');
        
        FileNameTest = strcat(dataPathTest,'\',CallNames{i},'CallsTestMaster.wav');
        
        TrainwaveIn = audioread(FileNameTrain);

        TestwaveIn = audioread(FileNameTest);
        
        TrainFeatures = harmonicRatio(TrainwaveIn,fs,'Window',hnrWndw,'OverlapLength',wlist(j)/2); 
        
        TestFeatures = harmonicRatio(TestwaveIn,fs,'Window',hnrWndw,'OverlapLength',wlist(j)/2);       
        
        % normalize the data
        TrainNormFeatures = ((TrainFeatures-mu))./sigma;
        TestNormFeatures = ((TestFeatures-mu))./sigma;
        
        save(strcat(TrainingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_', CallNames{i}, '.mat'),'TrainNormFeatures')
        save(strcat(TestingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_', CallNames{i}, '.mat'),'TestNormFeatures')
        
    end
    
end



