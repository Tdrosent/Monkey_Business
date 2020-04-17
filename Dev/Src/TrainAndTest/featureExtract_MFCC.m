% feature exctraction
function featureExtract_MFCC()
dataPathTrain = char('../../../Data/MasterTraining');
dataPathTest = char('../../../Data/MasterTesting');
addpath(dataPathTrain)
addpath(dataPathTest)

fs = 96000;
CallNames      = {'peep','peepString','phee','trill', 'tsik','tsikString','twitter'};

FullData = [];
for i = 1:length(CallNames)
    FileNameTrain = strcat(dataPathTrain,'\',CallNames{i},'CallsTrainMaster.wav');
    [y,~]= audioread(FileNameTrain);
    FullData = [FullData ; y];
end

windowSizeList = [ 0.02, 0.05, 0.1, 0.2];
wlist = round(windowSizeList *fs);
l = floor(.4.*wlist);
mstimeList = windowSizeList * 10^3;
numCoeffsList = 12;

for k = 1:length(numCoeffsList)
    for j = 1:length(windowSizeList)
        TrainingFolderName = strcat('../../../Data/Features/Training/MFCC',num2str(j),num2str(k));
        TestingFolderName  = strcat('../../../Data/Features/Testing/MFCC',num2str(j),num2str(k));

        %First extract the features from the Full Data, Z-Score
        %normailization must be done on all of the data not on a call by
        %call basis
        [coeffsFull,deltaFull,deltaDeltaFull] = mfcc(FullData,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
        FullFeatures = [coeffsFull,deltaFull,deltaDeltaFull];
        
        %Dynamically computing z-score Normalization factors
        FullFeatures(find(abs(FullFeatures) == inf)) = NaN;
        mu = nanmean(FullFeatures(2:end));
        sigma = nanstd(FullFeatures);
        NormalizationFactor.mu = mu;
        NormalizationFactor.sigma=sigma;
        
        if ~exist(TrainingFolderName,'dir')
                mkdir(TrainingFolderName);
        end
        
        if ~exist(TestingFolderName,'dir')
            mkdir(TestingFolderName);
        end
        
        save(strcat(TrainingFolderName,'/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor');
        
        for i = 1:length(CallNames)

            FileNameTrain = strcat(dataPathTrain,'\',CallNames{i},'CallsTrainMaster.wav');
            
            FileNameTest = strcat(dataPathTest,'\',CallNames{i},'CallsTestMaster.wav');

            TrainwaveIn = audioread(FileNameTrain);
            
            TestwaveIn = audioread(FileNameTest);
            
            [coeffsTrain,deltaTrain,deltaDeltaTrain] = mfcc(TrainwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            [coeffsTest,deltaTest,deltaDeltaTest] = mfcc(TestwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            
            TrainFeatures = [coeffsTrain,deltaTrain,deltaDeltaTrain];
            TestFeatures = [coeffsTest,deltaTest,deltaDeltaTest];
            
            % normalize the data
            TrainNormFeatures = ((TrainFeatures-mu))./sigma;
            TestNormFeatures = ((TestFeatures-mu))./sigma;


            save(strcat(TrainingFolderName,'/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_', CallNames{i}, '.mat'),'TrainNormFeatures')        

            save(strcat(TestingFolderName,'/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_', CallNames{i}, '.mat'),'TestNormFeatures')
        end
    end
end



