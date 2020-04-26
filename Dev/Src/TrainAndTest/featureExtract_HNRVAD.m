% feature exctraction
function featureExtract_HNRVAD()
dataPathTrain = char('../../../Data/MasterTrainingVAD');
dataPathTest = char('../../../Data/MasterTestingVAD');
addpath(dataPathTrain)
addpath(dataPathTest)

fs = 96000;

windowSizeList = [ 0.02, 0.05, 0.1, 0.2, 1];
wlist = round(windowSizeList *fs);
mstimeList = windowSizeList * 10^3;

peepFileName       = strcat(dataPathTrain,'\peepCallsTrainMaster.wav');
peepStringFileName = strcat(dataPathTrain,'\peepStringCallsTrainMaster.wav');
pheeFileName       = strcat(dataPathTrain,'\pheeCallsTrainMaster.wav');
trillFileName      = strcat(dataPathTrain,'\trillCallsTrainMaster.wav');
TsikFileName       = strcat(dataPathTrain,'\tsikCallsTrainMaster.wav');
TsikStringFileName = strcat(dataPathTrain,'\tsikStringCallsTrainMaster.wav');
TwitterFileName    = strcat(dataPathTrain,'\tsikStringCallsTrainMaster.wav');
NoVoiceFileName    = strcat(dataPathTrain,'\NoVoiceCallsTrainMaster.wav');

peepTrainData       = audioread(peepFileName);    
peepStringTrainData = audioread(peepStringFileName);
pheeTrainData       = audioread(pheeFileName);
trillTrainData      = audioread(trillFileName);
tsikTrainData       = audioread(TsikFileName);
tsikStringTrainData = audioread(TsikStringFileName);

twitterTrainData    = audioread(TwitterFileName);
noVoiceTrainData    = audioread(NoVoiceFileName);

%Splitting noVoice into 3 seprate files bc they are HUGE!
noVoiceTrainData1 = noVoiceTrainData(1:length(noVoiceTrainData)/3);
noVoiceTrainData2 = noVoiceTrainData(length(noVoiceTrainData)/3+1:length(noVoiceTrainData)/3*2);
noVoiceTrainData3 = noVoiceTrainData(length(noVoiceTrainData)/3*2+1:end);
clear noVoiceData

peepFileName       = strcat(dataPathTest,'\peepCallsTestMaster.wav');
peepStringFileName = strcat(dataPathTest,'\peepStringCallsTestMaster.wav');
pheeFileName       = strcat(dataPathTest,'\pheeCallsTestMaster.wav');
trillFileName      = strcat(dataPathTest,'\trillCallsTestMaster.wav');
TsikFileName       = strcat(dataPathTest,'\tsikCallsTestMaster.wav');
TsikStringFileName = strcat(dataPathTest,'\tsikStringCallsTestMaster.wav');
TwitterFileName    = strcat(dataPathTest,'\twitterCallsTestMaster.wav');
NoVoiceFileName    = strcat(dataPathTest,'\NoVoiceCallsTestMaster.wav');

peepTestData       = audioread(peepFileName);    
peepStringTestData = audioread(peepStringFileName);
pheeTestData       = audioread(pheeFileName);
trillTestData      = audioread(trillFileName);
tsikTestData       = audioread(TsikFileName);
tsikStringTestData = audioread(TsikStringFileName);
twitterTestData    = audioread(TwitterFileName);
noVoiceTestData    = audioread(NoVoiceFileName);

for j = 1:length(windowSizeList)
    TrainingFolderName = strcat('../../../Data/FeaturesVAD/Training/HNR',num2str(j));
    TestingFolderName  = strcat('../../../Data/FeaturesVAD/Testing/HNR',num2str(j));
    FullFeatures=[];
    if ~exist(TrainingFolderName,'dir')
        mkdir(TrainingFolderName);
    end
    if ~exist(TestingFolderName,'dir')
        mkdir(TestingFolderName);
    end
    hnrWndw = hamming(wlist(j));
    
    peepFeatures       = harmonicRatio(peepTrainData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    peepStringFeatures = harmonicRatio(peepStringTrainData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    pheeFeatures       = harmonicRatio(pheeTrainData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    trillFeatures      = harmonicRatio(trillTrainData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    tsikFeatures       = harmonicRatio(tsikTrainData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    tsikStringFeatures = harmonicRatio(tsikStringTrainData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    twitterFeatures    = harmonicRatio(twitterTrainData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    %Combining all voiced features
    VoicedFeatures = [peepFeatures;peepStringFeatures;pheeFeatures;trillFeatures;tsikFeatures;tsikStringFeatures;twitterFeatures];
    clear peepFeatures peepStringFeatures pheeFeatures trillFeatures tsikFeatures tsikStringFeatures twitterFeatures
    
    %No Voiced is split into 3 due to size
    NoVoiceFeatures1   = harmonicRatio(noVoiceTrainData1, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    NoVoiceFeatures2   = harmonicRatio(noVoiceTrainData2, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    NoVoiceFeatures3   = harmonicRatio(noVoiceTrainData3, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    %Combining all non-voiced features
    UnVoicedFeatures = [NoVoiceFeatures1;NoVoiceFeatures2;NoVoiceFeatures3];
    
    clear NoVoiceFeatures1 NoVoiceFeatures2 NoVoiceFeatures3
    
    %Building up full feature set to compute normalization factors
    FullFeatures = [VoicedFeatures;UnVoicedFeatures];

    %Dynamically computing z-score Normalization factors
    mu = mean(FullFeatures);
    sigma = std(FullFeatures);
    NormalizationFactor.mu = mu;
    NormalizationFactor.sigma=sigma;
    clear FullFeatures
    
    save(strcat(TrainingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor')
    
    %Loading in the testing data
    peepFeaturesTest       = harmonicRatio(peepTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    peepStringFeaturesTest = harmonicRatio(peepStringTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    pheeFeaturesTest       = harmonicRatio(pheeTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    trillFeaturesTest      = harmonicRatio(trillTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    tsikFeaturesTest       = harmonicRatio(tsikTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    tsikStringFeaturesTest = harmonicRatio(tsikStringTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    twitterFeaturesTest    = harmonicRatio(twitterTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    
    VoicedTestFeatures = [peepFeaturesTest;peepStringFeaturesTest;pheeFeaturesTest;trillFeaturesTest;tsikFeaturesTest;tsikStringFeaturesTest;twitterFeaturesTest];
    clear peepFeaturesTest peepStringFeaturesTest pheeFeaturesTest trillFeaturesTest tsikFeaturesTest tsikStringFeaturesTest twitterFeaturesTest
    
    noVoiceFeaturesTest = harmonicRatio(noVoiceTestData, fs, 'Window', hnrWndw,'OverlapLength',wlist(j)/2);
    
    % normalize the data
    TrainNormFeaturesVoiced = ((VoicedFeatures-mu))./sigma;
    TestNormFeaturesVoiced = ((VoicedTestFeatures-mu))./sigma;
    
    TrainNormFeaturesUnVoiced = ((UnVoicedFeatures-mu))./sigma;
    TestNormFeaturesUnVoiced = ((noVoiceFeaturesTest-mu))./sigma;
    
    save(strcat(TrainingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_Voiced.mat'),'TrainNormFeaturesVoiced')
    save(strcat(TestingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_Voiced.mat'),'TestNormFeaturesVoiced')
    
    save(strcat(TrainingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_UnVoiced.mat'),'TrainNormFeaturesUnVoiced')
    save(strcat(TestingFolderName,'/Features_','HNR_',num2str(mstimeList(j)),'ms_UnVoiced.mat'),'TestNormFeaturesUnVoiced')
           
end



