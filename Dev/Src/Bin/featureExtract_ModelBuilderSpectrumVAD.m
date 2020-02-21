% feature exctraction
function featureExtract_ModelBuilderSpectrum()

addpath('Data')
addpath('NEEDED')

fs = 96000;
%% Loading in all Training Data
ComboCallsTrain1 = audioread('NEEDED/Training/comboCallsTrain.wav');
ComboCallsTrain2 =audioread('NEEDED/Training/comboCallsTrain2.wav');

NoVoiceCallsTrain1 = audioread('NEEDED/Training/noVoiceCallsTrain.wav');
NoVoiceCallsTrain2 = audioread('NEEDED/Training/noVoiceCallsTrain2.wav');

PeepCallsTrain1 = audioread('NEEDED/Training/peepCallsTrain.wav');
PeepCallsTrain2 =audioread('NEEDED/Training/peepCallsTrain2.wav');

peepStringCallsTrain1 = audioread('NEEDED/Training/peepStringCallsTrain.wav');
peepStringCallsTrain2 =audioread('NEEDED/Training/peepStringCallsTrain2.wav');

PheeCallsTrain1 = audioread('NEEDED/Training/pheeCallsTrain.wav');
PheeCallsTrain2 = audioread('NEEDED/Training/pheeCallsTrain2.wav');

TrillCallsTrain1 = audioread('NEEDED/Training/trillCallsTrain.wav');
TrillCallsTrain2 = audioread('NEEDED/Training/trillCallsTrain2.wav');

TsikCallsTrain1 = audioread('NEEDED/Training/tsikCallsTrain.wav');
TsikCallsTrain2 = audioread('NEEDED/Training/tsikCallsTrain2.wav');

TsikStringCallsTrain1 = audioread('NEEDED/Training/tsikStringCallsTrain.wav');
TsikStringCallsTrain2 = audioread('NEEDED/Training/tsikStringCallsTrain2.wav');

[TwitterTrain1,FS] = audioread('NEEDED/Training/twitterCallsTrain.wav');
TwitterTrain2 = audioread('NEEDED/Training/twitterCallsTrain2.wav');

VoicedDataTrain = [ComboCallsTrain1;ComboCallsTrain2;PeepCallsTrain1;PeepCallsTrain2;peepStringCallsTrain1;peepStringCallsTrain2;...
              PheeCallsTrain1;PheeCallsTrain2;TrillCallsTrain1;TrillCallsTrain2;TsikCallsTrain1;TsikCallsTrain2;TsikStringCallsTrain1;...
              TsikStringCallsTrain2;TwitterTrain1;TwitterTrain2];
          
unVoicedDataTrain = [NoVoiceCallsTrain1;NoVoiceCallsTrain2];
FullDataTrain = [VoicedDataTrain;unVoicedDataTrain];

%% Loading in all Testing Data
ComboCallsTest1 = audioread('NEEDED/Testing/comboCallsTest.wav');
ComboCallsTest2 =audioread('NEEDED/Testing/comboCallsTest2.wav');

NoVoiceCallsTest1 = audioread('NEEDED/Testing/noVoiceCallsTest.wav');
NoVoiceCallsTest2 = audioread('NEEDED/Testing/noVoiceCallsTest2.wav');

PeepCallsTest1 = audioread('NEEDED/Testing/peepCallsTest.wav');
PeepCallsTest2 =audioread('NEEDED/Testing/peepCallsTest2.wav');

peepStringCallsTest1 = audioread('NEEDED/Testing/peepStringCallsTest.wav');
peepStringCallsTest2 =audioread('NEEDED/Testing/peepStringCallsTest2.wav');

PheeCallsTest1 = audioread('NEEDED/Testing/pheeCallsTest.wav');
PheeCallsTest2 = audioread('NEEDED/Testing/pheeCallsTest2.wav');

TrillCallsTest1 = audioread('NEEDED/Testing/trillCallsTest.wav');
TrillCallsTest2 = audioread('NEEDED/Testing/trillCallsTest2.wav');

TsikCallsTest1 = audioread('NEEDED/Testing/tsikCallsTest.wav');
TsikCallsTest2 = audioread('NEEDED/Testing/tsikCallsTest2.wav');

TsikStringCallsTest1 = audioread('NEEDED/Testing/tsikStringCallsTest.wav');
TsikStringCallsTest2 = audioread('NEEDED/Testing/tsikStringCallsTest2.wav');

[TwitterTest1,FS] = audioread('NEEDED/Testing/twitterCallsTest.wav');
TwitterTest2 = audioread('NEEDED/Testing/twitterCallsTest2.wav');

VoicedDataTest = [ComboCallsTest1;ComboCallsTest2;PeepCallsTest1;PeepCallsTest2;peepStringCallsTest1;peepStringCallsTest2;...
              PheeCallsTest1;PheeCallsTest2;TrillCallsTest1;TrillCallsTest2;TsikCallsTest1;TsikCallsTest2;TsikStringCallsTest1;...
              TsikStringCallsTest2;TwitterTest1;TwitterTest2];
          
unVoicedDataTest = [NoVoiceCallsTest1;NoVoiceCallsTest2];
FullDataTest = [VoicedDataTest;unVoicedDataTest];


windowSizeList = [ 0.02, 0.05, 0.1, 0.2];
% windowSizeList = [ 0.01, 0.025, 0.075, 0.105, 0.250, .750, 1];
wlist = round(windowSizeList *fs);
l = floor(.4.*wlist);
mstimeList = windowSizeList * 10^3;
numCoeffsList =[120,200];
    
% will change this to num of PCA componets in a
% bit
% audiowrite('NEEDED/Training/VoicedData.wav',VoicedDataTrain,FS)
% audiowrite('NEEDED/Training/unVoicedData.wav',unVoicedDataTrain ,FS)
% audiowrite('NEEDED/Testing/VoicedData.wav',VoicedDataTest,FS)
% audiowrite('NEEDED/Testing/unVoicedData.wav',unVoicedDataTest ,FS)
for k = 1:length(numCoeffsList)
    for j = 1:length(windowSizeList)
        %Dynamically computing z-score Normalization factors
        %         FullFeatures = getPSDFeatures(FullData,wlist(j),l(j));
        [~,~,~,FullFeatures] = spectrogram(FullDataTrain,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
        FullFeatures=FullFeatures';
        mu = mean(FullFeatures);
        sigma = std(FullFeatures);
        NormalizationFactor.mu = mu;
        NormalizationFactor.sigma=sigma;
%         NormedFeatures = (FullFeatures - mu)./sigma;
%         [~, ~,~,~,explained,~] = pca(NormedFeatures);
%         if ~exist(strcat('NEEDED/RegularizationTrainSpec/MODEL',num2str(j),num2str(k)),'dir')
%             mkdir(strcat('NEEDED/RegularizationTrainSpec/MODEL',num2str(j),num2str(k)));
%         end
%         save(strcat('NEEDED/RegularizationTrainSpec/MODEL',num2str(j),num2str(k),'/Features_waveFile_PcaExplained.mat'),'explained')
%         if ~exist(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k)),'dir')
%             mkdir(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k)));
%         end
%         Saving data for Z-score
%         save(strcat('NEEDED/ModelsTrainSpec/MODEL',num2str(j),num2str(k),'/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor')
        for i = 1:2
            
            waveFile = CallNames{i};
            
%             TrainwaveIn1 = audioread(['NEEDED/Training/VoicedData.wav']);
%             TrainwaveIn2 = audioread(['NEEDED/Training/' waveFile 'Train2.wav']);
%             
%             TestwaveIn1 = audioread(['NEEDED/Testing/' waveFile 'Test.wav']);
%             TestwaveIn2 = audioread(['NEEDED/Testing/' waveFile 'Test2.wav']);
%             TestwaveIn = [TestwaveIn1;TestwaveIn2];
            
            [~,~,~,TrainFeaturesVoiced] = spectrogram(VoicedDataTrain,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
            TrainFeaturesVoiced = TrainFeaturesVoiced';
            
            [~,~,~,TrainFeaturesUnVoiced] = spectrogram(unVoicedDataTrain,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
            TrainFeaturesUnVoiced = TrainFeaturesUnVoiced';
            
            %             TrainFeatures = getPSDFeatures(TrainwaveIn,wlist(j),l(j));
            [~,~,~,TestFeaturesVoiced] = spectrogram(VoicedDataTest,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
            TestFeaturesVoiced=TestFeaturesVoiced';
            
            [~,~,~,TestFeaturesUnVoiced] = spectrogram(UnVoicedDataTest,wlist(j),l(j),2^ceil(log2(wlist(j))),fs);
            TestFeaturesUnVoiced=TestFeaturesUnVoiced';
            %             TestFeatures = getPSDFeatures(TestwaveIn,wlist(j),l(j));
            
            % normalize the data
            TrainNormFeaturesVoiced = ((TrainFeaturesVoiced-mu))./sigma;
            TrainNormFeaturesUnVoiced = ((TrainFeaturesUnVoiced-mu))./sigma;
            
            
            TestNormFeaturesVoiced = ((TestFeaturesVoiced-mu))./sigma;
            TestNormFeaturesUnVoiced = ((TestFeaturesUnVoiced-mu))./sigma;
            
            [coeffs,scoreTrain,~,~,explained,mu] = pca(TrainNormFeatures,'NumComponents',numCoeffsList(k));
            PCAStruct.coeffs = coeffs;
            PCAStruct.mu = mu;
            
            %Projecting testing data to same dimension using the basis
            %funcion from above
            
            scoreTest = bsxfun(@minus,TestNormFeatures,mu)*coeffs;
            
            if ~exist(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
                mkdir(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'));
            end
            if ~exist(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
                mkdir(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'));
            end
            if ~exist(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/Analyze/'),'dir')
                mkdir(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/Analyze/'));
            end
            if ~exist(strcat('NEEDED/RegularizationTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'),'dir')
                mkdir(strcat('NEEDED/RegularizationTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/'));
            end
            
            
            %Saving "explain" matrix
%             save(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_', waveFile,'_PcaExplained.mat'),'explained')
%             %saving PCA structure, can use to project new data onto new basis functions
%             save(strcat('NEEDED/RegularizationTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/PCA_Features_',num2str(numCoeffsList(k)),'Componets__',num2str(mstimeList(j)),'ms_', waveFile,'_PCAStruct.mat'),'PCAStruct')
%             
            save(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/Analyze/Spectrum_Features_',num2str(mstimeList(j)),'ms_', waveFile, '.mat'),'TrainNormFeatures')
            
            %saving PCA'd Training Data
%             save(strcat('NEEDED/ModelsTrainSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_', waveFile, '.mat'),'scoreTrain')
%             %saving PCA'd Training Data
%             save(strcat('NEEDED/ModelsTestSpec/MODEL2/MODEL',num2str(j),num2str(k),'/Normalized/PCA_Features_',num2str(numCoeffsList(k)),'Componets_',num2str(mstimeList(j)),'ms_', waveFile, '.mat'),'scoreTest')
        end
    end
end



