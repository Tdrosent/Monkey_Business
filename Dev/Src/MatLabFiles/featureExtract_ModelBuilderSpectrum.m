% feature exctraction
function featureExtract_ModelBuilderSpectrum()

addpath('Data')
addpath('NEEDED')

fs = 96000;
CallNames = {'twitterCalls','pheeCalls','trillCalls'};
% CallNames = {'comboCalls','noVoiceCalls','peepCalls','peepString','twitterCalls','pheeCalls','trillCalls'};

Twitter1 = audioread('NEEDED/Training/twitterCallsTrain.wav');
Twitter2 = audioread('NEEDED/Training/twitterCallsTrain2.wav');
PheeCalls1 = audioread('NEEDED/Training/pheeCallsTrain.wav');
PheeCalls2 = audioread('NEEDED/Training/pheeCallsTrain2.wav');
TrillCalls1 = audioread('NEEDED/Training/trillCallsTrain.wav');
TrillCalls2 = audioread('NEEDED/Training/trillCallsTrain2.wav');


TwitterCalls = [Twitter1;Twitter2];
PheeCalls = [PheeCalls1;PheeCalls2];
TrillCalls = [TrillCalls1;TrillCalls2];

FullDataTrain = [TwitterCalls;PheeCalls;TrillCalls];



TwitterCallsTest1 = audioread('NEEDED/Testing/twitterCallsTest.wav');
TwitterCallsTest2 = audioread('NEEDED/Testing/twitterCallsTest2.wav');
PheeCallsTest1 = audioread('NEEDED/Testing/pheeCallsTest.wav');
PheeCallsTest2 = audioread('NEEDED/Testing/pheeCallsTest2.wav');
TrillCallsTest1 = audioread('NEEDED/Testing/trillCallsTest.wav');
TrillCallsTest2 = audioread('NEEDED/Testing/trillCallsTest2.wav');

TwitterCallsTest = [TwitterCallsTest1;TwitterCallsTest2];
PheeCallsTest = [PheeCallsTest1;PheeCallsTest2];
TrillCallsTest = [TrillCallsTest1;TrillCallsTest2];

FullDataTest = [TwitterCallsTest;PheeCallsTest;TrillCallsTest];

windowSizeList = [ 0.02, 0.05, 0.1, 0.2];
% windowSizeList = [ 0.01, 0.025, 0.075, 0.105, 0.250, .750, 1];
wlist = round(windowSizeList *fs);
l = floor(.4.*wlist);
mstimeList = windowSizeList * 10^3;
numCoeffsList =[120];

% will change this to num of PCA componets in a
% bit

for k = 1:length(numCoeffsList)
    for j = 1:length(windowSizeList)
        scoreTest=[];
        scoreTrain=[];
        %Dynamically computing z-score Normalization factors
        %         FullFeatures = getPSDFeatures(FullData,wlist(j),l(j));

        [~,~,~,TwitterFeatures] = spectrogram(TwitterCalls,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
        [~,~,~,PheeFeatures] = spectrogram(PheeCalls,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
        [~,~,~,TrillFeatures] = spectrogram(TrillCalls,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
        TwitterFeatures=TwitterFeatures';
        PheeFeatures=PheeFeatures';
        TrillFeatures=TrillFeatures';
        
        TwitterLength = size(TwitterFeatures,1);
        PheeLength = size(PheeFeatures,1);
        TrillLength = size(TrillFeatures,1);
        
        FullFeatures = [TwitterFeatures;PheeFeatures;TrillFeatures];
        
        
%         FullFeatures=FullFeatures';
        mu = mean(FullFeatures);
        sigma = std(FullFeatures);
        NormalizationFactor.mu = mu;
        NormalizationFactor.sigma=sigma;
        NormedFeaturesTrain = (FullFeatures - mu)./sigma;
        
        [~,~,~,TwitterFeaturesTest] = spectrogram(TwitterCallsTest,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
        [~,~,~,PheeFeaturesTest] = spectrogram(PheeCallsTest,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
        [~,~,~,TrillFeaturesTest] = spectrogram(TrillCallsTest,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
        TwitterFeaturesTest=TwitterFeaturesTest';
        PheeFeaturesTest=PheeFeaturesTest';
        TrillFeaturesTest=TrillFeaturesTest';
        
        TwitterTestLength = size(TwitterFeaturesTest,1);
        PheeTestLength = size(PheeFeaturesTest,1);
        TrillTestLength = size(TrillFeaturesTest,1);

        TestFeatures=[TwitterFeaturesTest;PheeFeaturesTest;TrillFeaturesTest];
        % normalize the data
        TestNormFeatures = ((TestFeatures-mu))./sigma;
        
        
        [coeffs,scoreTrain,~,~,~,mu] = pca(NormedFeaturesTrain,'NumComponents',numCoeffsList(k));       
        PCAStruct.coeffs = coeffs;
        PCAStruct.mu = mu;

        TwitterTrainPCA = scoreTrain(1:TwitterLength,:);
        PheeTrainPCA = scoreTrain(TwitterLength+1:TwitterLength+PheeLength,:);
        TrillTrainPCA = scoreTrain(TwitterLength+PheeLength+1:TwitterLength+PheeLength+TrillLength,:);
        
        %Projecting testing data to same dimension using the basis
        %funcion from above
        
        scoreTest = bsxfun(@minus,TestNormFeatures,mu)*coeffs;

        TwitterTestPCA = scoreTest(1:TwitterTestLength,:);
        PheeTestPCA = scoreTest(TwitterTestLength+1:TwitterTestLength+PheeTestLength,:);
        TrillTestPCA = scoreTest(TwitterTestLength+PheeTestLength+1:TwitterTestLength+PheeTestLength+TrillTestLength,:);
        
        if ~exist(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
            mkdir(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'));
        end
        if ~exist(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
            mkdir(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'));
        end
%         if ~exist(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/Analyze/'),'dir')
%             mkdir(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/Analyze/'));
%         end
        if ~exist(strcat('NEEDED/RegularizationTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
            mkdir(strcat('NEEDED/RegularizationTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'));
        end
        
       
        %Saving "explain" matrix
        %             save(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_', waveFile,'_PcaExplained.mat'),'explained')
        %             %saving PCA structure, can use to project new data onto new basis functions
        %             save(strcat('NEEDED/RegularizationTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/PCA_Features_',num2str(numCoeffsList(k)),'Componets__',num2str(mstimeList(j)),'ms_', waveFile,'_PCAStruct.mat'),'PCAStruct')
        %
%         save(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/Analyze/Spectrum_Features_',num2str(mstimeList(j)),'ms_', waveFile, '.mat'),'TrainNormFeatures')

%         saving PCA'd Training Data
        save(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_Twitter.mat'),'TwitterTrainPCA')
        save(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_Phee.mat'),'PheeTrainPCA')
        save(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_Trill.mat'),'TrillTrainPCA')

        %saving PCA'd Test Data
        save(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_Twitter.mat'),'TwitterTestPCA')
        save(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_Phee.mat'),'PheeTestPCA')
        save(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_Trill.mat'),'TrillTestPCA')
    end
end



