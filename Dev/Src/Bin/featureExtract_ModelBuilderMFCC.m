% feature exctraction
function featureExtract_ModelBuilderMFCC()

addpath('Data')
addpath('NEEDED')

fs = 96000;
CallNames = {'twitterCalls','pheeCalls','trillCalls'};

Twitter1 = audioread(['NEEDED/Training/twitterCallsTrain.wav']);
Twitter2 = audioread(['NEEDED/Training/twitterCallsTrain2.wav']);
PheeCalls1 = audioread(['NEEDED/Training/pheeCallsTrain.wav']);
PheeCalls2 = audioread(['NEEDED/Training/pheeCallsTrain2.wav']);
TrillCalls1 = audioread(['NEEDED/Training/trillCallsTrain.wav']);
TrillCalls2 = audioread(['NEEDED/Training/trillCallsTrain2.wav']);


FullData = [Twitter1;Twitter2;PheeCalls1;PheeCalls2;TrillCalls1;TrillCalls2];

windowSizeList = [ 0.02, 0.05, 0.1, 0.2];
% windowSizeList = [ 0.01, 0.025, 0.075, 0.105, 0.250, .750, 1];
wlist = round(windowSizeList *fs);
l = floor(.4.*wlist);
mstimeList = windowSizeList * 10^3;
numCoeffsList = [12];

for k = 1:length(numCoeffsList)
    for j = 1:length(windowSizeList)
        %Dynamically computing z-score Normalization factors
        [coeffsFull,deltaFull,deltaDeltaFull] = mfcc(FullData,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
        FullFeatures = [coeffsFull,deltaFull,deltaDeltaFull];
        mu = mean(FullFeatures);
        sigma = std(FullFeatures);
        NormalizationFactor.mu = mu;
        NormalizationFactor.sigma=sigma;
        if ~exist(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k)),'dir')
                mkdir(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k)));
        end
        save(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor')
        for i = 1:length(CallNames)

            waveFile = CallNames{i};
            
            TrainwaveIn1 = audioread(['NEEDED/Training/' waveFile 'Train.wav']);
            TrainwaveIn2 = audioread(['NEEDED/Training/' waveFile 'Train2.wav']);
            TrainwaveIn = [TrainwaveIn1;TrainwaveIn2];
            
            TestwaveIn1 = audioread(['NEEDED/Testing/' waveFile 'Test.wav']);
            TestwaveIn2 = audioread(['NEEDED/Testing/' waveFile 'Test2.wav']);
            TestwaveIn = [TestwaveIn1;TestwaveIn2];
            
            [coeffsTrain,deltaTrain,deltaDeltaTrain] = mfcc(TrainwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            [coeffsTest,deltaTest,deltaDeltaTest] = mfcc(TestwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            
            TrainFeatures = [coeffsTrain,deltaTrain,deltaDeltaTrain];
            TestFeatures = [coeffsTest,deltaTest,deltaDeltaTest];
            
            % normalize the data
            TrainNormFeatures = ((TrainFeatures-mu))./sigma;
            TestNormFeatures = ((TestFeatures-mu))./sigma;

            if ~exist(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
                mkdir(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Normalized/'));
            end
            if ~exist(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Regular/'),'dir')
                mkdir(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Regular/'));
            end
            
            if ~exist(strcat('NEEDED/ModelsTest/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
                mkdir(strcat('NEEDED/ModelsTest/MODEL',num2str(j),num2str(k),'/Normalized/'));
            end
            if ~exist(strcat('NEEDED/ModelsTest/MODEL',num2str(j),num2str(k),'/Regular/'),'dir')
                mkdir(strcat('NEEDED/ModelsTest/MODEL',num2str(j),num2str(k),'/Regular/'));
            end

            save(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Normalized/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_FULL_', waveFile, '.mat'),'TrainNormFeatures')
            save(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Regular/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_FULL_', waveFile, '.mat'),'TrainNormFeatures')
            

            save(strcat('NEEDED/ModelsTest/MODEL',num2str(j),num2str(k),'/Normalized/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_FULL_', waveFile, '.mat'),'TestNormFeatures')
            save(strcat('NEEDED/ModelsTest/MODEL',num2str(j),num2str(k),'/Regular/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_FULL_', waveFile, '.mat'),'TestNormFeatures')
        end
    end
end



