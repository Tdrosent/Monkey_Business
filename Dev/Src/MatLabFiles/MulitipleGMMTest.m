function MulitipleGMMTest()
clear
clc
addpath('NEEDED/')

Bigpath = dir('NEEDED/ModelsTrain');
Bigpath2 = dir('NEEDED/ModelsTest');

if ~exist('TestingResults','dir')
    mkdir('TestingResults');
end
if ~exist('TestingResults\ModelResults','dir')
    mkdir('TestingResults\ModelResults');
end

if ~exist('TestingResults\Model','dir')
    mkdir('TestingResults\Model');
end
addpath('TestingResults')
K = [8 16 32 64];
for p = 1:length(K)
    for z = 3:length(Bigpath)
        subClass = dir(strcat('NEEDED/ModelsTrain/',Bigpath(z).name));
        subClass2 = dir(strcat('NEEDED/ModelsTest/',Bigpath2(z).name));
        
        NormalizedTrainFolder = dir(strcat(subClass(1).folder,'\Normalized\*.mat'));
        NormalizedTestFolder = dir(strcat(subClass2(1).folder,'\Normalized\*.mat'));
        
        for l = 1:length({NormalizedTrainFolder.folder})
            NormalizedTrainCallsName(l) = {strcat(NormalizedTrainFolder(l).folder,'\',NormalizedTrainFolder(l).name)};
            NormalizedTestCallsName(l) = {strcat(NormalizedTestFolder(l).folder,'\',NormalizedTestFolder(l).name)};
        end
        
        % load in normalized mfcc features
        % comboNorm = load(NormalizedCallsName{1});
        % comboNormFullData = comboNorm.normFeatures(:,:);
        % cv = cvpartition(size(comboNormFullData,1),'HoldOut',0.20);
        % indxCombo = cv.test;
        % Call.combo.NormFullTrainData = comboNormFullData(~indxCombo,:);
        % Call.combo.NormFullTestData = comboNormFullData(indxCombo,:);
        
        % lengthComboNorm = length(comboNorm);
        
        
        % noVoiceNorm = load(NormalizedCallsName{2});
        % noVoiceNormFullData = noVoiceNorm.normFeatures(:,:);
        % cv = cvpartition(size(noVoiceNormFullData,1),'HoldOut',0.20);
        % indxnoVoice = cv.test;
        % Call.noVoice.NormFullTrainData = noVoiceNormFullData(~indxnoVoice,:);
        % Call.noVoice.NormFullTestData = noVoiceNormFullData(indxnoVoice,:);
        
        % lengthNoVoiceNorm = length(noVoiceNorm);
        
        % peepNorm = load(NormalizedCallsName{3});
        % peepNormFullData = peepNorm.normFeatures(:,:);
        % cv = cvpartition(size(peepNormFullData,1),'HoldOut',0.20);
        % indxpeep = cv.test;
        % Call.peep.NormFullTrainData = peepNormFullData(~indxpeep,:);
        % Call.peep.NormFullTestData = peepNormFullData(indxpeep,:);
        
        % peepStringNorm = load(NormalizedCallsName{4});
        % peepStringNorm = peepStringNorm.normFeatures(:,:);
        % peepNorm = [peepNorm;peepStringNorm];
        % lengthPeepNorm = length(peepNorm);
        
        
        
        pheeNormTrain = load(NormalizedTrainCallsName{1});
        pheeNormFullTrainData = pheeNormTrain.TrainNormFeatures(:,:);
        
        pheeNormTest = load(NormalizedTestCallsName{1});
        pheeNormFullTestData = pheeNormTest.TestNormFeatures(:,:);
        
        Call.phee.NormFullTrainData = pheeNormFullTrainData;
        Call.phee.NormFullTestData =pheeNormFullTestData;
        % lengthPheeNorm = length(pheeNorm);
        
        trillNormTrain = load(NormalizedTrainCallsName{2});
        trillNormFullTrainData = trillNormTrain.TrainNormFeatures(:,:);
        
        trillNormTest = load(NormalizedTestCallsName{2});
        trillNormFullTestData = trillNormTest.TestNormFeatures(:,:);
        
        Call.trill.NormFullTrainData = trillNormFullTrainData;
        Call.trill.NormFullTestData =trillNormFullTestData;
        
        
        % lengthTrillNorm = length(trillNorm);
        
        % tsikNorm = load(NormalizedCallsName{7});
        % tsikNormFullData = tsikNorm.normFeatures(:,:);
        % cv = cvpartition(size(tsikNormFullData,1),'HoldOut',0.20);
        % indxtsik = cv.test;
        % Call.tsik.NormFullTrainData = tsikNormFullData(~indxtsik,:);
        % Call.tsik.NormFullTestData = tsikNormFullData(indxtsik,:);
        
        % tsikStringNorm = load(NormalizedCallsName{8});
        % tsikStringNorm = tsikStringNorm.normFeatures(:,:);
        % tsikNorm = [tsikNorm;tsikStringNorm];
        % lengthTsikNorm = length(tsikNorm);
        
        twitterNormTrain = load(NormalizedTrainCallsName{3});
        twitterNormFullTrainData = twitterNormTrain.TrainNormFeatures(:,:);
        
        twitterNormTest = load(NormalizedTestCallsName{3});
        twitterNormFullTestData = twitterNormTest.TestNormFeatures(:,:);
        
        Call.twitter.NormFullTrainData = twitterNormFullTrainData;
        Call.twitter.NormFullTestData =twitterNormFullTestData;
        
        % lengthTwitterNorm = length(twitterNorm);
        % fullFeatureNorm = [comboNorm ;peepNorm ;tsikNorm; noVoiceNorm;twitterNorm;trillNorm;pheeNorm];
        Names = fieldnames(Call);
        
        PheeVTrillErr.(Bigpath(z).name) =0;
        PheeVTwitterErr.(Bigpath(z).name)=0;
        
        TrillVPheeErr.(Bigpath(z).name) =0;
        TrillVTwitterErr.(Bigpath(z).name)=0;
        
        TwitterVPheeErr.(Bigpath(z).name) =0;
        TwitterVTrillErr.(Bigpath(z).name)=0;
        PredictedPhee1 = [];
        PredictedPhee2 = [];
        PredictedTrill1 = [];
        PredictedTrill2 = [];
        PredictedTwitter1 =[];
        PredictedTwitter2 = [];
        try
            for i = 1:length(Names)
                %'Replicates',5,
                GMM.(Names{i}) =fitgmdist(Call.(Names{i}).NormFullTrainData,K(p),'Replicates',5,'CovarianceType','diagonal','Options',statset('Display','iter','MaxIter',1200));
                disp(['Finished itteration ', num2str(i), '/',num2str(length(Names))])
                disp(['GMM was built with ', num2str(K(p)),' mixtures'])
            end
            %% Evaluating Phees
            %% Phee V Trill
            PredictedPhee1(:,1) = pdf(GMM.phee,Call.phee.NormFullTestData);
            PredictedPhee1(:,2) = pdf(GMM.trill,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee1)
                if PredictedPhee1(j,1) < PredictedPhee1(j,2)
                    PheeVTrillErr.(Bigpath(z).name) = PheeVTrillErr.(Bigpath(z).name) +1;
                end
            end
            PheeVTrillPercentError.(Bigpath(z).name) = PheeVTrillErr.(Bigpath(z).name)/length(PredictedPhee1)*100;
            
            
            %% Phee V Twitter
            PredictedPhee2(:,1) = PredictedPhee1(:,1);
            PredictedPhee2(:,2) = pdf(GMM.twitter,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee2)
                if PredictedPhee2(j,1) < PredictedPhee2(j,2)
                    PheeVTwitterErr.(Bigpath(z).name) = PheeVTwitterErr.(Bigpath(z).name) +1;
                end
            end
            PheeVTwitterPercentError.(Bigpath(z).name) = PheeVTwitterErr.(Bigpath(z).name)/length(PredictedPhee1)*100;
            
            
            %% Evaluating Trills
            %% Trill V Phee
            PredictedTrill1(:,1) = pdf(GMM.trill,Call.trill.NormFullTestData);
            PredictedTrill1(:,2) = pdf(GMM.phee,Call.trill.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill1(j,1) < PredictedTrill1(j,2)
                    TrillVPheeErr.(Bigpath(z).name) = TrillVPheeErr.(Bigpath(z).name) +1;
                end
            end
            TrillVPheePercentError.(Bigpath(z).name) = TrillVPheeErr.(Bigpath(z).name)/length(PredictedTrill1)*100;
            
            
            
            PredictedTrill2(:,1) = PredictedTrill1(:,1);
            PredictedTrill2(:,2) = pdf(GMM.twitter,Call.trill.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill2(j,1) < PredictedTrill2(j,2)
                    TrillVTwitterErr.(Bigpath(z).name) = TrillVTwitterErr.(Bigpath(z).name) +1;
                end
            end
            TrillVTwitterPercentError.(Bigpath(z).name) = TrillVTwitterErr.(Bigpath(z).name)/length(PredictedTrill1)*100;
            
            
            
            
            %% Evaluating Twitters
            PredictedTwitter1(:,1) = pdf(GMM.twitter,Call.twitter.NormFullTestData);
            PredictedTwitter1(:,2) = pdf(GMM.phee,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTwitter1(j,1) < PredictedTwitter1(j,2)
                    TwitterVPheeErr.(Bigpath(z).name) =  TwitterVPheeErr.(Bigpath(z).name) +1;
                end
            end
            TwitterVPheePercentError.(Bigpath(z).name) = TwitterVPheeErr.(Bigpath(z).name)/length(PredictedTrill1)*100;
            
            
            
            
            PredictedTwitter2(:,1) = PredictedTwitter1(:,1);
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            (:,2) = pdf(GMM.trill,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTwitter2(j,1) < PredictedTwitter2(j,2)
                    TwitterVTrillErr.(Bigpath(z).name) =  TwitterVTrillErr.(Bigpath(z).name) +1;
                end
            end
            TwitterVTrillPercentError.(Bigpath(z).name) = TwitterVTrillErr.(Bigpath(z).name)/length(PredictedTrill1)*100;
            
            
            disp(['Just Finished ', Bigpath(z).name, ' It had the following missclassification'])
            disp(' ')
            disp(['Phee Vs Trill Error = ', num2str(PheeVTrillErr.(Bigpath(z).name)), ' %Error is ',num2str(PheeVTrillPercentError.(Bigpath(z).name)) ])
            disp(['Phee Vs Twitter Error = ', num2str(PheeVTwitterErr.(Bigpath(z).name)), ' %Error is ',num2str(PheeVTwitterPercentError.(Bigpath(z).name)) ])
            disp(['Trill Vs Phee Error = ', num2str(TrillVPheeErr.(Bigpath(z).name)), ' %Error is ',num2str(TrillVPheePercentError.(Bigpath(z).name)) ])
            disp(['Trill Vs Twitter Error = ', num2str(TrillVTwitterErr.(Bigpath(z).name)), ' %Error is ',num2str(TrillVTwitterPercentError.(Bigpath(z).name)) ])
            disp(['Twitter Vs Phee Error = ', num2str(TwitterVPheeErr.(Bigpath(z).name)), ' %Error is ',num2str(TwitterVPheePercentError.(Bigpath(z).name)) ])
            disp(['Twitter Vs Trill Error = ', num2str(TwitterVTrillErr.(Bigpath(z).name)), ' %Error is ',num2str(TwitterVTrillPercentError.(Bigpath(z).name)) ])
            
            fileName = strcat('./TestingResults/ModelResults/',Bigpath(z).name,'_',num2str(K(p)),'.txt');
            fileID = fopen(fileName,'w');
            fprintf(fileID,'Number of mixtures = %i, %s\n', K(p), NormalizedTrainFolder(1).name(1:21));
            fprintf(fileID,'Just Finished %s_%i It had the following missclassification\n', Bigpath(z).name,K(p));
            fprintf(fileID,'Phee Vs Trill    Error = %i/%i, Percent Error =%f  \n', PheeVTrillErr.(Bigpath(z).name),length(pheeNormFullTestData), PheeVTrillPercentError.(Bigpath(z).name) );
            fprintf(fileID,'Phee Vs Twitter  Error = %i/%i, Percent Error =%f  \n', PheeVTwitterErr.(Bigpath(z).name),length(pheeNormFullTestData),PheeVTwitterPercentError.(Bigpath(z).name) );
            fprintf(fileID,'Trill Vs Phee    Error = %i/%i, Percent Error =%f  \n', TrillVPheeErr.(Bigpath(z).name),length(trillNormFullTestData),TrillVPheePercentError.(Bigpath(z).name) );
            fprintf(fileID,'Trill Vs Twitter Error = %i/%i, Percent Error =%f  \n', TrillVTwitterErr.(Bigpath(z).name),length(trillNormFullTestData),TrillVTwitterPercentError.(Bigpath(z).name) );
            fprintf(fileID,'Twitter Vs Phee  Error = %i/%i, Percent Error =%f  \n', TwitterVPheeErr.(Bigpath(z).name),length(twitterNormFullTestData),TwitterVPheePercentError.(Bigpath(z).name) );
            fprintf(fileID,'Twitter Vs Trill Error = %i/%i, Percent Error =%f  \n', TwitterVTrillErr.(Bigpath(z).name),length(twitterNormFullTestData),TwitterVTrillPercentError.(Bigpath(z).name) );
            fclose(fileID);
            
            Model.(Bigpath(z).name).PheeVTrillErr = PheeVTrillErr.(Bigpath(z).name);
            Model.(Bigpath(z).name).PheeVTrillPercentError = PheeVTrillPercentError.(Bigpath(z).name);
            
            Model.(Bigpath(z).name).PheeVTwitterErr =PheeVTwitterErr.(Bigpath(z).name);
            Model.(Bigpath(z).name).PheeVTwitterPercentError = PheeVTwitterPercentError.(Bigpath(z).name);
            
            Model.(Bigpath(z).name).TrillVPheeErr = TrillVPheeErr.(Bigpath(z).name);
            Model.(Bigpath(z).name).TrillVPheePercentError = TrillVPheePercentError.(Bigpath(z).name);
            
            Model.(Bigpath(z).name).TrillVTwitterErr = TrillVTwitterErr.(Bigpath(z).name);
            Model.(Bigpath(z).name).TrillVTwitterPercentError = TrillVTwitterPercentError.(Bigpath(z).name);
            
            Model.(Bigpath(z).name).TwitterVPheeErr =TwitterVPheeErr.(Bigpath(z).name);
            Model.(Bigpath(z).name).TwitterVPheePercentError = TwitterVPheePercentError.(Bigpath(z).name);
            
            Model.(Bigpath(z).name).TwitterVTrillErr = TwitterVTrillErr.(Bigpath(z).name);
            Model.(Bigpath(z).name).TwitterVTrillPercentError = TwitterVTrillPercentError.(Bigpath(z).name);
            
            save(strcat('./TestingResults/Model/',Bigpath(z).name,'_',num2str(K(p)),'.mat'),'Model')
            save(strcat('./TestingResults/Model/',Bigpath(z).name,'_',num2str(K(p)),'GMMModel.mat'),'GMM')
            
            clear Model
        catch exception
            fileName = strcat('./TestingResults/ModelResults/',Bigpath(z).name,'_',num2str(K(p)),'.txt');
            fileID = fopen(fileName,'w');
            fprintf(fileID,'%s', 'This model has broken. Most likely due to the GMM failing to converge');
            fprintf(fileID,'\nERROR:\n%s', exception.message);
            fclose(fileID);
            disp('Starting next itteration on ')
            %             disp(strcat('Starting next itteration on ', Bigpath(z+1).name))
        end
        
    end
    %     save(strcat('./TestingVectors/TestVectors.mat'),'Call')
end
end
