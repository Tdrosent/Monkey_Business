function MulitipleGMMMFCCTest()
clear
clc

path1 = '../../../Data/Features/Training/MFCC';
path2 = '../../../Data/Features/Testing/MFCC';
path3 = '../../../Data/TestingResults/MFCC';
addpath(path1)
addpath(path2)

BigPath = dir(path1);
Bigpath2 = dir(path2);

if ~exist(path3,'dir')
    mkdir(path3);
end


K = [8 16 32 64];
for p = 1:length(K)
    %Starting index @ 3 because the first two entries in BigPath are '.'
    %and '..' and we don't need these
    for z = 3:length(BigPath)
        subClass = dir(strcat(path1,'\',BigPath(z).name));
        subClass2 = dir(strcat(path2,'\',Bigpath2(z).name));
        
        NormalizedTrainFolder = dir(strcat(subClass(1).folder,'\*.mat'));
        NormalizedTestFolder = dir(strcat(subClass2(1).folder,'\*.mat'));
        
        for l = 1:length({NormalizedTrainFolder.folder})
            NormalizedTrainCallsName(l) = {strcat(NormalizedTrainFolder(l).folder,'\',NormalizedTrainFolder(l).name)};
            NormalizedTestCallsName(l) = {strcat(NormalizedTestFolder(l).folder,'\',NormalizedTestFolder(l).name)};
        end
        
% ------------------------------------------------------------------------%
%                       Loading in Peep Data                              %
% ------------------------------------------------------------------------%
        peepNormTrain = load(NormalizedTrainCallsName{1});
        peepNormFullTrainData = peepNormTrain.TrainNormFeatures(:,:);
        
        peepNormTest = load(NormalizedTestCallsName{1});
        peepNormFullTestData = peepNormTest.TestNormFeatures(:,:);
        
        Call.peep.NormFullTrainData = peepNormFullTrainData;
        Call.peep.NormFullTestData  = peepNormFullTestData;
        %Initialize Variable to count Errors
        PredictedPeep1 = [];
% ------------------------------------------------------------------------%
%                 Loading in PeepString Data                              %
% ------------------------------------------------------------------------%
        peepStringNormTrain = load(NormalizedTrainCallsName{2});
        peepStringNormFullTrainData = peepStringNormTrain.TrainNormFeatures(:,:);
        
        peepStringNormTest = load(NormalizedTestCallsName{2});
        peepStringNormFullTestData = peepStringNormTest.TestNormFeatures(:,:);
        
        Call.peepString.NormFullTrainData = peepStringNormFullTrainData;
        Call.peepString.NormFullTestData  = peepStringNormFullTestData;
        %Initialize Variable to count Errors
        PredictedPeepString1 = [];
% ------------------------------------------------------------------------%
%                       Loading in Phee Data                              %
% ------------------------------------------------------------------------%
        pheeNormTrain = load(NormalizedTrainCallsName{3});
        pheeNormFullTrainData = pheeNormTrain.TrainNormFeatures(:,:);
        
        pheeNormTest = load(NormalizedTestCallsName{3});
        pheeNormFullTestData = pheeNormTest.TestNormFeatures(:,:);
        
        Call.phee.NormFullTrainData = pheeNormFullTrainData;
        Call.phee.NormFullTestData  = pheeNormFullTestData;
        %Initialize Variable to count Errors
        PredictedPhee1 = [];
% ------------------------------------------------------------------------%
%                       Loading in Trill Data                             %
% ------------------------------------------------------------------------%
        trillNormTrain = load(NormalizedTrainCallsName{4});
        trillNormFullTrainData = trillNormTrain.TrainNormFeatures(:,:);
        
        trillNormTest = load(NormalizedTestCallsName{4});
        trillNormFullTestData = trillNormTest.TestNormFeatures(:,:);
        
        Call.trill.NormFullTrainData = trillNormFullTrainData;
        Call.trill.NormFullTestData  = trillNormFullTestData;
        %Initialize Variable to count Errors
        PredictedTrill1 = [];
% ------------------------------------------------------------------------%
%                       Loading in Tsik Data                              %
% ------------------------------------------------------------------------%
        tsikNormTrain = load(NormalizedTrainCallsName{5});
        tsikNormFullTrainData = tsikNormTrain.TrainNormFeatures(:,:);
        
        tsikNormTest = load(NormalizedTestCallsName{5});
        tsikNormFullTestData = tsikNormTest.TestNormFeatures(:,:);
        
        Call.tsik.NormFullTrainData = tsikNormFullTrainData;
        Call.tsik.NormFullTestData  = tsikNormFullTestData;
        %Initialize Variable to count Errors
        PredictedTsik1 = [];
% ------------------------------------------------------------------------%
%                       Loading in TsikString Data                        %
% ------------------------------------------------------------------------%
        tsikStringNormTrain = load(NormalizedTrainCallsName{6});
        tsikStringNormFullTrainData = tsikStringNormTrain.TrainNormFeatures(:,:);
        
        tsikStringNormTest = load(NormalizedTestCallsName{6});
        tsikStringNormFullTestData = tsikStringNormTest.TestNormFeatures(:,:);
        
        Call.tsikString.NormFullTrainData = tsikStringNormFullTrainData;
        Call.tsikString.NormFullTestData  = tsikStringNormFullTestData;
        %Initialize Variable to count Errors
        PredictedTsikString1 = [];
% ------------------------------------------------------------------------%
%                       Loading in Twitter Data                           %
% ------------------------------------------------------------------------%
        twitterNormTrain = load(NormalizedTrainCallsName{6});
        twitterNormFullTrainData = twitterNormTrain.TrainNormFeatures(:,:);
        
        twitterNormTest = load(NormalizedTestCallsName{6});
        twitterNormFullTestData = twitterNormTest.TestNormFeatures(:,:);
        
        Call.twitter.NormFullTrainData = twitterNormFullTrainData;
        Call.twitter.NormFullTestData =twitterNormFullTestData;
        %Initialize Variable to count Errors
        PredictedTwitter1 = [];
% ------------------------------------------------------------------------%
%                          END OF DATA LOAD                               %
% ------------------------------------------------------------------------%
        %Variable used to name the GMM's to keep it clean
        Names = fieldnames(Call);
% ------------------------------------------------------------------------%
%                       Error Structure Creation                          %
%_________________________________________________________________________%
% This section will create structures to hold errors in. Every single pair%
% Will need to be enumerated in this section. Each Section should have 6  %
% pairs.                                                                  %
% ------------------------------------------------------------------------%
        
        % Peep
        PeepVPeepStringErr.(BigPath(z).name)=0;
        PeepVPheeErr.(BigPath(z).name)=0;
        PeepVTrillErr.(BigPath(z).name)=0;
        PeepVTsikErr.(BigPath(z).name)=0;
        PeepVTsikStringErr.(BigPath(z).name)=0;
        PeepVTwitterErr.(BigPath(z).name)=0;
        
        % PeepString
        PeepStringVPeepErr.(BigPath(z).name)=0;
        PeepStringVPheeErr.(BigPath(z).name)=0;
        PeepStringVTrillErr.(BigPath(z).name)=0;
        PeepStringVTsikErr.(BigPath(z).name)=0;
        PeepStringVTsikStringErr.(BigPath(z).name)=0;
        PeepStringVTwitterErr.(BigPath(z).name)=0;
        
        % Phee
        PheeVPeepErr.(BigPath(z).name)=0;
        PheeVPeepStringErr.(BigPath(z).name)=0;
        PheeVTrillErr.(BigPath(z).name)=0;
        PheeVTsikErr.(BigPath(z).name)=0;
        PheeVTsikStringErr.(BigPath(z).name)=0;
        PheeVTwitterErr.(BigPath(z).name)=0;
        
        %Trill
        TrillVPeepErr.(BigPath(z).name)=0;
        TrillVPeepStringErr.(BigPath(z).name)=0;
        TrillVPheeErr.(BigPath(z).name)=0;
        TrillVTsikErr.(BigPath(z).name)=0;
        TrillVTsikStringErr.(BigPath(z).name)=0;
        TrillVTwitterErr.(BigPath(z).name)=0;
        
        %Tsik
        TsikVPeepErr.(BigPath(z).name)=0;
        TsikVPeepStringErr.(BigPath(z).name)=0;
        TsikVPheeErr.(BigPath(z).name)=0;
        TsikVTrillErr.(BigPath(z).name)=0;
        TsikVTsikStringErr.(BigPath(z).name)=0;
        TsikVTwitterErr.(BigPath(z).name)=0;
        
        %TsikString
        TsikStringVPeepErr.(BigPath(z).name)=0;
        TsikStringVPeepStringErr.(BigPath(z).name)=0;
        TsikStringVPheeErr.(BigPath(z).name)=0;
        TsikStringVTrillErr.(BigPath(z).name)=0;
        TsikStringVTsikErr.(BigPath(z).name)=0;
        TsikStringVTwitterErr.(BigPath(z).name)=0;
        
        %Twitter
        TwitterVPeepErr.(BigPath(z).name)=0;
        TwitterVPeepStringErr.(BigPath(z).name)=0;
        TwitterVPheeErr.(BigPath(z).name)=0;
        TwitterVTrillErr.(BigPath(z).name)=0;
        TwitterVTsikErr.(BigPath(z).name)=0;
        TwitterVTsikStringErr.(BigPath(z).name)=0;
% ------------------------------------------------------------------------%
%                          END  Structure Creation                        %
% ------------------------------------------------------------------------%


% ------------------------------------------------------------------------%
%                            Training GMM's                               %
% ------------------------------------------------------------------------%
        try
            for i = 1:length(Names)
                %'Replicates',5,
                GMM.(Names{i}) =fitgmdist(Call.(Names{i}).NormFullTrainData,K(p),'Replicates',5,'CovarianceType','diagonal','Options',statset('Display','iter','MaxIter',1200));
                disp(['Finished itteration ', num2str(i), '/',num2str(length(Names))])
                disp(['GMM was built with ', num2str(K(p)),' mixtures'])
            end
            
% ------------------------------------------------------------------------%
%                          Evaluating Peep GMM's                          %
% ------------------------------------------------------------------------%
            %Peep Vs PeepString
            PredictedPeep1(:,1) = pdf(GMM.peep      ,Call.peep.NormFullTestData);
            PredictedPeep1(:,2) = pdf(GMM.peepString,Call.peep.NormFullTestData);
            for j = 1:length(PredictedPeep1)
                if PredictedPeep1(j,1) < PredictedPeep1(j,2)
                    PeepVPeepStringErr.(BigPath(z).name) = PeepVPeepStringErr.(BigPath(z).name) +1;
                end
            end
            PeepVPeepStringPercentError.(BigPath(z).name) = PeepVPeepStringErr.(BigPath(z).name)/length(PredictedPeep1)*100;
            
            %Peep Vs Phee
            PredictedPeep1(:,1) = pdf(GMM.peep,Call.peep.NormFullTestData);
            PredictedPeep1(:,2) = pdf(GMM.phee,Call.peep.NormFullTestData);
            for j = 1:length(PredictedPeep1)
                if PredictedPeep1(j,1) < PredictedPeep1(j,2)
                    PeepVPheeErr.(BigPath(z).name) = PeepVPheeErr.(BigPath(z).name) +1;
                end
            end
            PeepVPheePercentError.(BigPath(z).name) = PeepVPheeErr.(BigPath(z).name)/length(PredictedPeep1)*100;
            
            %Peep Vs Trill
            PredictedPeep1(:,1) = pdf(GMM.peep ,Call.peep.NormFullTestData);
            PredictedPeep1(:,2) = pdf(GMM.trill,Call.peep.NormFullTestData);
            for j = 1:length(PredictedPeep1)
                if PredictedPeep1(j,1) < PredictedPeep1(j,2)
                    PeepVTrillErr.(BigPath(z).name) = PeepVTrillErr.(BigPath(z).name) +1;
                end
            end
            PeepVTrillPercentError.(BigPath(z).name) = PeepVTrillErr.(BigPath(z).name)/length(PredictedPeep1)*100;
            
            %Peep Vs Tsik
            PredictedPeep1(:,1) = pdf(GMM.peep ,Call.peep.NormFullTestData);
            PredictedPeep1(:,2) = pdf(GMM.trill,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedPeep1)
                if PredictedPeep1(j,1) < PredictedPeep1(j,2)
                    PeepVTsikErr.(BigPath(z).name) = PeepVTsikErr.(BigPath(z).name) +1;
                end
            end
            PeepVTsikPercentError.(BigPath(z).name) = PeepVTsikErr.(BigPath(z).name)/length(PredictedPeep1)*100;
            
            %Peep Vs TsikString
            PredictedPeep1(:,1) = pdf(GMM.peep ,Call.peep.NormFullTestData);
            PredictedPeep1(:,2) = pdf(GMM.trill,Call.tsikString.NormFullTestData);
            for j = 1:length(PredictedPeep1)
                if PredictedPeep1(j,1) < PredictedPeep1(j,2)
                    PeepVTsikStringErr.(BigPath(z).name) = PeepVTsikStringErr.(BigPath(z).name) +1;
                end
            end
            PeepVTsikStringPercentError.(BigPath(z).name) = PeepVTsikStringErr.(BigPath(z).name)/length(PredictedPeep1)*100;
            
            %Peep Vs Twitter
            PredictedPeep1(:,1) = pdf(GMM.peep ,Call.peep.NormFullTestData);
            PredictedPeep1(:,2) = pdf(GMM.trill,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedPeep1)
                if PredictedPeep1(j,1) < PredictedPeep1(j,2)
                    PeepVTwitterErr.(BigPath(z).name) = PeepVTwitterErr.(BigPath(z).name) +1;
                end
            end
            PeepVTwitterPercentError.(BigPath(z).name) = PeepVTwitterErr.(BigPath(z).name)/length(PredictedPeep1)*100;
            
% ------------------------------------------------------------------------%
%                          Evaluating PeepString GMM's                    %
% ------------------------------------------------------------------------%
            %PeepString Vs Peep
            PredictedPeepString1(:,1) = pdf(GMM.peepString,Call.peepString.NormFullTestData);
            PredictedPeepString1(:,2) = pdf(GMM.peep      ,Call.peepString.NormFullTestData);
            for j = 1:length(PredictedPeepString1)
                if PredictedPeepString1(j,1) < PredictedPeepString1(j,2)
                    PeepStringVPeepErr.(BigPath(z).name) = PeepStringVPeepErr.(BigPath(z).name) +1;
                end
            end
            PeepStringVPeepPercentError.(BigPath(z).name) = PeepStringVPeepErr.(BigPath(z).name)/length(PredictedPeepString1)*100;
            
            %PeepString Vs Phee
            PredictedPeepString1(:,1) = pdf(GMM.peepString,Call.peepString.NormFullTestData);
            PredictedPeepString1(:,2) = pdf(GMM.phee      ,Call.peepString.NormFullTestData);
            for j = 1:length(PredictedPeepString1)
                if PredictedPeepString1(j,1) < PredictedPeepString1(j,2)
                    PeepStringVPheeErr.(BigPath(z).name) = PeepStringVPheeErr.(BigPath(z).name) +1;
                end
            end
            PeepStringVPheePercentError.(BigPath(z).name) = PeepStringVPheeErr.(BigPath(z).name)/length(PredictedPeepString1)*100;
            
            %PeepString Vs Trill
            PredictedPeepString1(:,1) = pdf(GMM.peepString,Call.peepString.NormFullTestData);
            PredictedPeepString1(:,2) = pdf(GMM.trill     ,Call.peepString.NormFullTestData);
            for j = 1:length(PredictedPeepString1)
                if PredictedPeepString1(j,1) < PredictedPeepString1(j,2)
                    PeepStringVTrillErr.(BigPath(z).name) = PeepStringVTrillErr.(BigPath(z).name) +1;
                end
            end
            PeepStringVTrillPercentError.(BigPath(z).name) = PeepStringVTrillErr.(BigPath(z).name)/length(PredictedPeepString1)*100;
            
            %PeepString Vs Tsik
            PredictedPeepString1(:,1) = pdf(GMM.peepString,Call.peepString.NormFullTestData);
            PredictedPeepString1(:,2) = pdf(GMM.tsik      ,Call.peepString.NormFullTestData);
            for j = 1:length(PredictedPeepString1)
                if PredictedPeepString1(j,1) < PredictedPeepString1(j,2)
                    PeepStringVTsikErr.(BigPath(z).name) = PeepStringVTsikErr.(BigPath(z).name) +1;
                end
            end
            PeepStringVTsikPercentError.(BigPath(z).name) = PeepStringVTsikErr.(BigPath(z).name)/length(PredictedPeepString1)*100;
            
            %PeepString Vs TsikString
            PredictedPeepString1(:,1) = pdf(GMM.peepString,Call.peepString.NormFullTestData);
            PredictedPeepString1(:,2) = pdf(GMM.tsikString,Call.peepString.NormFullTestData);
            for j = 1:length(PredictedPeepString1)
                if PredictedPeepString1(j,1) < PredictedPeepString1(j,2)
                    PeepStringVTsikStringErr.(BigPath(z).name) = PeepStringVTsikStringErr.(BigPath(z).name) +1;
                end
            end
            PeepStringVTsikStringPercentError.(BigPath(z).name) = PeepStringVTsikStringErr.(BigPath(z).name)/length(PredictedPeepString1)*100;
            
            %PeepString Vs Twitter
            PredictedPeepString1(:,1) = pdf(GMM.peepString,Call.peepString.NormFullTestData);
            PredictedPeepString1(:,2) = pdf(GMM.twitter   ,Call.peepString.NormFullTestData);
            for j = 1:length(PredictedPeepString1)
                if PredictedPeepString1(j,1) < PredictedPeepString1(j,2)
                    PeepStringVTwitterErr.(BigPath(z).name) = PeepStringVTwitterErr.(BigPath(z).name) +1;
                end
            end
            PeepStringVTwitterPercentError.(BigPath(z).name) = PeepStringVTwitterErr.(BigPath(z).name)/length(PredictedPeepString1)*100;
            
% ------------------------------------------------------------------------%
%                           Evaluating Phee GMM's                         %
% ------------------------------------------------------------------------%
            %Phee Vs Peep
            PredictedPhee1(:,1) = pdf(GMM.phee,Call.phee.NormFullTestData);
            PredictedPhee1(:,2) = pdf(GMM.peep,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee1)
                if PredictedPhee1(j,1) < PredictedPhee1(j,2)
                    PheeVPeepErr.(BigPath(z).name) = PheeVPeepErr.(BigPath(z).name) +1;
                end
            end
            PheeVPeepPercentError.(BigPath(z).name) = PheeVPeepErr.(BigPath(z).name)/length(PredictedPhee1)*100;
            
            %Phee Vs PeepString
            PredictedPhee1(:,1) = pdf(GMM.phee      ,Call.phee.NormFullTestData);
            PredictedPhee1(:,2) = pdf(GMM.peepString,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee1)
                if PredictedPhee1(j,1) < PredictedPhee1(j,2)
                    PheeVPeepStringErr.(BigPath(z).name) = PheeVPeepStringErr.(BigPath(z).name) +1;
                end
            end
            PheeVPeepStringPercentError.(BigPath(z).name) = PheeVPeepStringErr.(BigPath(z).name)/length(PredictedPhee1)*100;
            
            %Phee Vs Trill
            PredictedPhee1(:,1) = pdf(GMM.phee ,Call.phee.NormFullTestData);
            PredictedPhee1(:,2) = pdf(GMM.trill,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee1)
                if PredictedPhee1(j,1) < PredictedPhee1(j,2)
                    PheeVTrillErr.(BigPath(z).name) = PheeVTrillErr.(BigPath(z).name) +1;
                end
            end
            PheeVTrillPercentError.(BigPath(z).name) = PheeVTrillErr.(BigPath(z).name)/length(PredictedPhee1)*100;
            
            %Phee Vs Tsik
            PredictedPhee1(:,1) = pdf(GMM.phee ,Call.phee.NormFullTestData);
            PredictedPhee1(:,2) = pdf(GMM.tsik ,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee1)
                if PredictedPhee1(j,1) < PredictedPhee1(j,2)
                    PheeVTsikErr.(BigPath(z).name) = PheeVTsikErr.(BigPath(z).name) +1;
                end
            end
            PheeVTsikPercentError.(BigPath(z).name) = PheeVTsikErr.(BigPath(z).name)/length(PredictedPhee1)*100;
            
            %Phee Vs TsikString
            PredictedPhee1(:,1) = pdf(GMM.phee       ,Call.phee.NormFullTestData);
            PredictedPhee1(:,2) = pdf(GMM.tsikString ,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee1)
                if PredictedPhee1(j,1) < PredictedPhee1(j,2)
                    PheeVTsikStringErr.(BigPath(z).name) = PheeVTsikStringErr.(BigPath(z).name) +1;
                end
            end
            PheeVTsikStringPercentError.(BigPath(z).name) = PheeVTsikStringErr.(BigPath(z).name)/length(PredictedPhee1)*100;
            
            %Phee Vs Twitter
            PredictedPhee1(:,1) = pdf(GMM.phee    ,Call.phee.NormFullTestData);
            PredictedPhee1(:,2) = pdf(GMM.twitter ,Call.phee.NormFullTestData);
            for j = 1:length(PredictedPhee1)
                if PredictedPhee1(j,1) < PredictedPhee1(j,2)
                    PheeVTwitterErr.(BigPath(z).name) = PheeVTwitterErr.(BigPath(z).name) +1;
                end
            end
            PheeVTwitterPercentError.(BigPath(z).name) = PheeVTwitterErr.(BigPath(z).name)/length(PredictedPhee1)*100;
            
% ------------------------------------------------------------------------%
%                           Evaluating Trill GMM's                        %
% ------------------------------------------------------------------------%
            %Trill Vs Peep
            PredictedTrill1(:,1) = pdf(GMM.trill,Call.trill.NormFullTestData);
            PredictedTrill1(:,2) = pdf(GMM.peep ,Call.trill.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill1(j,1) < PredictedTrill1(j,2)
                    TrillVPeepErr.(BigPath(z).name) = TrillVPeepErr.(BigPath(z).name) +1;
                end
            end
            TrillVPeepPercentError.(BigPath(z).name) = TrillVPeepErr.(BigPath(z).name)/length(PredictedTrill1)*100;
            
            %Trill Vs PeepString
            PredictedTrill1(:,1) = pdf(GMM.trill      ,Call.trill.NormFullTestData);
            PredictedTrill1(:,2) = pdf(GMM.peepString ,Call.trill.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill1(j,1) < PredictedTrill1(j,2)
                    TrillVPeepStringErr.(BigPath(z).name) = TrillVPeepStringErr.(BigPath(z).name) +1;
                end
            end
            TrillVPeepStringPercentError.(BigPath(z).name) = TrillVPeepStringErr.(BigPath(z).name)/length(PredictedTrill1)*100;
            
            %Trill Vs Phee
            PredictedTrill1(:,1) = pdf(GMM.trill ,Call.trill.NormFullTestData);
            PredictedTrill1(:,2) = pdf(GMM.phee  ,Call.trill.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill1(j,1) < PredictedTrill1(j,2)
                    TrillVPheeErr.(BigPath(z).name) = TrillVPheeErr.(BigPath(z).name) +1;
                end
            end
            TrillVPheePercentError.(BigPath(z).name) = TrillVPheeErr.(BigPath(z).name)/length(PredictedTrill1)*100;
            
            %Trill Vs Tsik
            PredictedTrill1(:,1) = pdf(GMM.trill ,Call.trill.NormFullTestData);
            PredictedTrill1(:,2) = pdf(GMM.tsik  ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill1(j,1) < PredictedTrill1(j,2)
                    TrillVTsikErr.(BigPath(z).name) = TrillVTsikErr.(BigPath(z).name) +1;
                end
            end
            TrillVTsikPercentError.(BigPath(z).name) = TrillVTsikErr.(BigPath(z).name)/length(PredictedTrill1)*100;
            
            %Trill Vs TsikString
            PredictedTrill1(:,1) = pdf(GMM.trill ,Call.trill.NormFullTestData);
            PredictedTrill1(:,2) = pdf(GMM.tsikString  ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill1(j,1) < PredictedTrill1(j,2)
                    TrillVTsikStringErr.(BigPath(z).name) = TrillVTsikStringErr.(BigPath(z).name) +1;
                end
            end
            TrillVTsikStringPercentError.(BigPath(z).name) = TrillVTsikStringErr.(BigPath(z).name)/length(PredictedTrill1)*100;
            
            %Trill Vs Twitter
            PredictedTrill1(:,1) = pdf(GMM.trill ,Call.trill.NormFullTestData);
            PredictedTrill1(:,2) = pdf(GMM.twitter  ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTrill1)
                if PredictedTrill1(j,1) < PredictedTrill1(j,2)
                    TrillVTwitterErr.(BigPath(z).name) = TrillVTwitterErr.(BigPath(z).name) +1;
                end
            end
            TrillVTwitterPercentError.(BigPath(z).name) = TrillVTwitterErr.(BigPath(z).name)/length(PredictedTrill1)*100;
            
% ------------------------------------------------------------------------%
%                           Evaluating Tsik GMM's                         %
% ------------------------------------------------------------------------%
            %Tsik Vs Peep
            PredictedTsik1(:,1) = pdf(GMM.tsik ,Call.tsik.NormFullTestData);
            PredictedTsik1(:,2) = pdf(GMM.peep ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTsik1)
                if PredictedTsik1(j,1) < PredictedTsik1(j,2)
                    TsikVPeepErr.(BigPath(z).name) = TsikVPeepErr.(BigPath(z).name) +1;
                end
            end
            TsikVPeepPercentError.(BigPath(z).name) = TsikVPeepErr.(BigPath(z).name)/length(PredictedTsik1)*100;
            
            %Tsik Vs PeepString
            PredictedTsik1(:,1) = pdf(GMM.tsik       ,Call.tsik.NormFullTestData);
            PredictedTsik1(:,2) = pdf(GMM.peepString ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTsik1)
                if PredictedTsik1(j,1) < PredictedTsik1(j,2)
                    TsikVPeepStringErr.(BigPath(z).name) = TsikVPeepStringErr.(BigPath(z).name) +1;
                end
            end
            TsikVPeepStringPercentError.(BigPath(z).name) = TsikVPeepStringErr.(BigPath(z).name)/length(PredictedTsik1)*100;
            
            %Tsik Vs Phee
            PredictedTsik1(:,1) = pdf(GMM.tsik ,Call.tsik.NormFullTestData);
            PredictedTsik1(:,2) = pdf(GMM.phee ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTsik1)
                if PredictedTsik1(j,1) < PredictedTsik1(j,2)
                    TsikVPheeErr.(BigPath(z).name) = TsikVPheeErr.(BigPath(z).name) +1;
                end
            end
            TsikVPheePercentError.(BigPath(z).name) = TsikVPheeErr.(BigPath(z).name)/length(PredictedTsik1)*100;
            
            %Tsik Vs Trill
            PredictedTsik1(:,1) = pdf(GMM.tsik  ,Call.tsik.NormFullTestData);
            PredictedTsik1(:,2) = pdf(GMM.trill ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTsik1)
                if PredictedTsik1(j,1) < PredictedTsik1(j,2)
                    TsikVTrillErr.(BigPath(z).name) = TsikVTrillErr.(BigPath(z).name) +1;
                end
            end
            TsikVTrillPercentError.(BigPath(z).name) = TsikVTrillErr.(BigPath(z).name)/length(PredictedTsik1)*100;
            
            %Tsik Vs TsikString
            PredictedTsik1(:,1) = pdf(GMM.tsik       ,Call.tsik.NormFullTestData);
            PredictedTsik1(:,2) = pdf(GMM.tsikString ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTsik1)
                if PredictedTsik1(j,1) < PredictedTsik1(j,2)
                    TsikVTsikStringErr.(BigPath(z).name) = TsikVTsikStringErr.(BigPath(z).name) +1;
                end
            end
            TsikVTsikStringPercentError.(BigPath(z).name) = TsikVTsikStringErr.(BigPath(z).name)/length(PredictedTsik1)*100;
            
            %Tsik Vs Twitter
            PredictedTsik1(:,1) = pdf(GMM.tsik    ,Call.tsik.NormFullTestData);
            PredictedTsik1(:,2) = pdf(GMM.twitter ,Call.tsik.NormFullTestData);
            for j = 1:length(PredictedTsik1)
                if PredictedTsik1(j,1) < PredictedTsik1(j,2)
                    TsikVTwitterErr.(BigPath(z).name) = TsikVTwitterErr.(BigPath(z).name) +1;
                end
            end
            TsikVTwitterPercentError.(BigPath(z).name) = TsikVTwitterErr.(BigPath(z).name)/length(PredictedTsik1)*100;
            
% ------------------------------------------------------------------------%
%                     Evaluating TsikString GMM's                         %
% ------------------------------------------------------------------------%
            %TsikString Vs Peep
            PredictedTsikString1(:,1) = pdf(GMM.tsikString ,Call.tsikString.NormFullTestData);
            PredictedTsikString1(:,2) = pdf(GMM.peep       ,Call.tsikString.NormFullTestData);
            for j = 1:length(PredictedTsikString1)
                if PredictedTsikString1(j,1) < PredictedTsikString1(j,2)
                    TsikStringVPeepErr.(BigPath(z).name) = TsikStringVPeepErr.(BigPath(z).name) +1;
                end
            end
            TsikStringVPeepPercentError.(BigPath(z).name) = TsikStringVPeepErr.(BigPath(z).name)/length(PredictedTsikString1)*100;
            
            %TsikString Vs PeepString
            PredictedTsikString1(:,1) = pdf(GMM.tsikString ,Call.tsikString.NormFullTestData);
            PredictedTsikString1(:,2) = pdf(GMM.peepString ,Call.tsikString.NormFullTestData);
            for j = 1:length(PredictedTsikString1)
                if PredictedTsikString1(j,1) < PredictedTsikString1(j,2)
                    TsikStringVPeepStringErr.(BigPath(z).name) = TsikStringVPeepStringErr.(BigPath(z).name) +1;
                end
            end
            TsikStringVPeepStringPercentError.(BigPath(z).name) = TsikStringVPeepStringErr.(BigPath(z).name)/length(PredictedTsikString1)*100;
            
            %TsikString Vs Phee
            PredictedTsikString1(:,1) = pdf(GMM.tsikString ,Call.tsikString.NormFullTestData);
            PredictedTsikString1(:,2) = pdf(GMM.phee       ,Call.tsikString.NormFullTestData);
            for j = 1:length(PredictedTsikString1)
                if PredictedTsikString1(j,1) < PredictedTsikString1(j,2)
                    TsikStringVPheeErr.(BigPath(z).name) = TsikStringVPheeErr.(BigPath(z).name) +1;
                end
            end
            TsikStringVPheePercentError.(BigPath(z).name) = TsikStringVPheeErr.(BigPath(z).name)/length(PredictedTsikString1)*100;
            
            %TsikString Vs Trill
            PredictedTsikString1(:,1) = pdf(GMM.tsikString ,Call.tsikString.NormFullTestData);
            PredictedTsikString1(:,2) = pdf(GMM.trill      ,Call.tsikString.NormFullTestData);
            for j = 1:length(PredictedTsikString1)
                if PredictedTsikString1(j,1) < PredictedTsikString1(j,2)
                    TsikStringVTrillErr.(BigPath(z).name) = TsikStringVTrillErr.(BigPath(z).name) +1;
                end
            end
            TsikStringVTrillPercentError.(BigPath(z).name) = TsikStringVTrillErr.(BigPath(z).name)/length(PredictedTsikString1)*100;
            
            %TsikString Vs Tsik
            PredictedTsikString1(:,1) = pdf(GMM.tsikString ,Call.tsikString.NormFullTestData);
            PredictedTsikString1(:,2) = pdf(GMM.tsik      ,Call.tsikString.NormFullTestData);
            for j = 1:length(PredictedTsikString1)
                if PredictedTsikString1(j,1) < PredictedTsikString1(j,2)
                    TsikStringVTsikErr.(BigPath(z).name) = TsikStringVTsikErr.(BigPath(z).name) +1;
                end
            end
            TsikStringVTsikPercentError.(BigPath(z).name) = TsikStringVTsikErr.(BigPath(z).name)/length(PredictedTsikString1)*100;
            
            %TsikString Vs Twitter
            PredictedTsikString1(:,1) = pdf(GMM.tsikString ,Call.tsikString.NormFullTestData);
            PredictedTsikString1(:,2) = pdf(GMM.twitter    ,Call.tsikString.NormFullTestData);
            for j = 1:length(PredictedTsikString1)
                if PredictedTsikString1(j,1) < PredictedTsikString1(j,2)
                    TsikStringVTwitterErr.(BigPath(z).name) = TsikStringVTwitterErr.(BigPath(z).name) +1;
                end
            end
            TsikStringVTwitterPercentError.(BigPath(z).name) = TsikStringVTwitterErr.(BigPath(z).name)/length(PredictedTsikString1)*100;
            
% ------------------------------------------------------------------------%
%                        Evaluating Twitter GMM's                         %
% ------------------------------------------------------------------------%
            %Twitter Vs Peep
            PredictedTwitter1(:,1) = pdf(GMM.twitter ,Call.twitter.NormFullTestData);
            PredictedTwitter1(:,2) = pdf(GMM.peep    ,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTwitter1)
                if PredictedTwitter1(j,1) < PredictedTwitter1(j,2)
                    TwitterVPeepErr.(BigPath(z).name) = TwitterVPeepErr.(BigPath(z).name) +1;
                end
            end
            TwitterVPeepPercentError.(BigPath(z).name) = TwitterVPeepErr.(BigPath(z).name)/length(PredictedTwitter1)*100;
            
            %Twitter Vs PeepString
            PredictedTwitter1(:,1) = pdf(GMM.twitter    ,Call.twitter.NormFullTestData);
            PredictedTwitter1(:,2) = pdf(GMM.peepString ,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTwitter1)
                if PredictedTwitter1(j,1) < PredictedTwitter1(j,2)
                    TwitterVPeepStringErr.(BigPath(z).name) = TwitterVPeepStringErr.(BigPath(z).name) +1;
                end
            end
            TwitterVPeepStringPercentError.(BigPath(z).name) = TwitterVPeepStringErr.(BigPath(z).name)/length(PredictedTwitter1)*100;
            
            %Twitter Vs Phee
            PredictedTwitter1(:,1) = pdf(GMM.twitter ,Call.twitter.NormFullTestData);
            PredictedTwitter1(:,2) = pdf(GMM.phee    ,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTwitter1)
                if PredictedTwitter1(j,1) < PredictedTwitter1(j,2)
                    TwitterVPheeErr.(BigPath(z).name) = TwitterVPheeErr.(BigPath(z).name) +1;
                end
            end
            TwitterVPheePercentError.(BigPath(z).name) = TwitterVPheeErr.(BigPath(z).name)/length(PredictedTwitter1)*100;
            
            %Twitter Vs Trill
            PredictedTwitter1(:,1) = pdf(GMM.twitter ,Call.twitter.NormFullTestData);
            PredictedTwitter1(:,2) = pdf(GMM.trill   ,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTwitter1)
                if PredictedTwitter1(j,1) < PredictedTwitter1(j,2)
                    TwitterVTrillErr.(BigPath(z).name) = TwitterVTrillErr.(BigPath(z).name) +1;
                end
            end
            TwitterVTrillPercentError.(BigPath(z).name) = TwitterVTrillErr.(BigPath(z).name)/length(PredictedTwitter1)*100;
            
            %Twitter Vs Tsik
            PredictedTwitter1(:,1) = pdf(GMM.twitter ,Call.twitter.NormFullTestData);
            PredictedTwitter1(:,2) = pdf(GMM.tsik   ,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTwitter1)
                if PredictedTwitter1(j,1) < PredictedTwitter1(j,2)
                    TwitterVTsikErr.(BigPath(z).name) = TwitterVTsikErr.(BigPath(z).name) +1;
                end
            end
            TwitterVTsikPercentError.(BigPath(z).name) = TwitterVTsikErr.(BigPath(z).name)/length(PredictedTwitter1)*100;
            
            %Twitter Vs TsikString
            PredictedTwitter1(:,1) = pdf(GMM.twitter    ,Call.twitter.NormFullTestData);
            PredictedTwitter1(:,2) = pdf(GMM.tsikString ,Call.twitter.NormFullTestData);
            for j = 1:length(PredictedTwitter1)
                if PredictedTwitter1(j,1) < PredictedTwitter1(j,2)
                    TwitterVTsikStringErr.(BigPath(z).name) = TwitterVTsikStringErr.(BigPath(z).name) +1;
                end
            end
            TwitterVTsikStringPercentError.(BigPath(z).name) = TwitterVTsikStringErr.(BigPath(z).name)/length(PredictedTwitter1)*100;

% ------------------------------------------------------------------------%
% !!!!!!!!!!!!!!!!!!!!!!!!!END OF EVALUATION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% ------------------------------------------------------------------------%
            
% ------------------------------------------------------------------------%
%                  Print Results out to Command Window                    %
% ------------------------------------------------------------------------%            
            
            disp(['Just Finished ', BigPath(z).name, ' It had the following missclassification'])
            disp(' ')
            % Peep Results
            disp('                 Peep Results                          ')
            disp(['Peep Vs PeepString Error = ', num2str(PeepVPeepStringErr.(BigPath(z).name)), ' %Error is ',num2str(PeepVPeepStringPercentError.(BigPath(z).name)) ])
            disp(['Peep Vs Phee Error = ',       num2str(PeepVPheeErr.(BigPath(z).name)), ' %Error is ',num2str(PeepVPheePercentError.(BigPath(z).name)) ])
            disp(['Peep Vs Trill Error = ',      num2str(PeepVTrillErr.(BigPath(z).name)), ' %Error is ',num2str(PeepVTrillPercentError.(BigPath(z).name)) ])
            disp(['Peep Vs Tsik Error = ',       num2str(PeepVTsikErr.(BigPath(z).name)), ' %Error is ',num2str(PeepVTsikPercentError.(BigPath(z).name)) ])
            disp(['Peep Vs TsikString Error = ', num2str(PeepVTsikStringErr.(BigPath(z).name)), ' %Error is ',num2str(PeepVTsikStringPercentError.(BigPath(z).name)) ])
            disp(['Peep Vs Twitter Error = ',    num2str(PeepVTwitterErr.(BigPath(z).name)), ' %Error is ',num2str(PeepVTwitterPercentError.(BigPath(z).name)) ]) 
            % PeepString Results
            disp('                 PeepString Results                          ')
            disp(['PeepString Vs Peep Error = ',       num2str(PeepStringVPeepErr.(BigPath(z).name)), ' %Error is ',num2str(PeepStringVPeepPercentError.(BigPath(z).name)) ])
            disp(['PeepString Vs Phee Error = ',       num2str(PeepStringVPheeErr.(BigPath(z).name)), ' %Error is ',num2str(PeepStringVPheePercentError.(BigPath(z).name)) ])
            disp(['PeepString Vs Trill Error = ',      num2str(PeepStringVTrillErr.(BigPath(z).name)), ' %Error is ',num2str(PeepStringVTrillPercentError.(BigPath(z).name)) ])
            disp(['PeepString Vs Tsik Error = ',       num2str(PeepStringVTsikErr.(BigPath(z).name)), ' %Error is ',num2str(PeepStringVTsikPercentError.(BigPath(z).name)) ])
            disp(['PeepString Vs TsikString Error = ', num2str(PeepStringVTsikStringErr.(BigPath(z).name)), ' %Error is ',num2str(PeepStringVTsikStringPercentError.(BigPath(z).name)) ])
            disp(['PeepString Vs Twitter Error = ',    num2str(PeepStringVTwitterErr.(BigPath(z).name)), ' %Error is ',num2str(PeepStringVTwitterPercentError.(BigPath(z).name)) ])             
            %Phee Results
            disp('                 Phee Results                          ')
            disp(['Phee Vs Peep Error = ',       num2str(PheeVPeepErr.(BigPath(z).name)), ' %Error is ',num2str(PheeVPeepPercentError.(BigPath(z).name)) ])
            disp(['Phee Vs PeepString Error = ', num2str(PheeVPeepStringErr.(BigPath(z).name)), ' %Error is ',num2str(PheeVPeepStringPercentError.(BigPath(z).name)) ])
            disp(['Phee Vs Trill Error = ',      num2str(PheeVTrillErr.(BigPath(z).name)), ' %Error is ',num2str(PheeVTrillPercentError.(BigPath(z).name)) ])
            disp(['Phee Vs Tsik Error = ',       num2str(PheeVTsikErr.(BigPath(z).name)), ' %Error is ',num2str(PheeVTsikPercentError.(BigPath(z).name)) ])
            disp(['Phee Vs TsikString Error = ', num2str(PheeVTsikStringErr.(BigPath(z).name)), ' %Error is ',num2str(PheeVTsikStringPercentError.(BigPath(z).name)) ])
            disp(['Phee Vs Twitter Error = ',    num2str(PheeVTwitterErr.(BigPath(z).name)), ' %Error is ',num2str(PheeVTwitterPercentError.(BigPath(z).name)) ])                      
            %Trill Results
            disp('                 Trill Results                          ')
            disp(['Trill Vs Peep Error = ',       num2str(TrillVPeepErr.(BigPath(z).name)), ' %Error is ',num2str(TrillVPeepPercentError.(BigPath(z).name)) ])
            disp(['Trill Vs PeepString Error = ', num2str(TrillVPeepStringErr.(BigPath(z).name)), ' %Error is ',num2str(TrillVPeepStringPercentError.(BigPath(z).name)) ])
            disp(['Trill Vs Phee Error = ',       num2str(TrillVPheeErr.(BigPath(z).name)), ' %Error is ',num2str(TrillVPheePercentError.(BigPath(z).name)) ])
            disp(['Trill Vs Tsik Error = ',       num2str(TrillVTsikErr.(BigPath(z).name)), ' %Error is ',num2str(TrillVTsikPercentError.(BigPath(z).name)) ])
            disp(['Trill Vs TsikString Error = ', num2str(TrillVTsikStringErr.(BigPath(z).name)), ' %Error is ',num2str(TrillVTsikStringPercentError.(BigPath(z).name)) ])
            disp(['Trill Vs Twitter Error = ',    num2str(TrillVTwitterErr.(BigPath(z).name)), ' %Error is ',num2str(TrillVTwitterPercentError.(BigPath(z).name)) ])             
            %Tsik Results
            disp('                 Tsik Results                          ')
            disp(['Tsik Vs Peep Error = ',       num2str(TsikVPeepErr.(BigPath(z).name)), ' %Error is ',num2str(TsikVPeepPercentError.(BigPath(z).name)) ])
            disp(['Tsik Vs PeepString Error = ', num2str(TsikVPeepStringErr.(BigPath(z).name)), ' %Error is ',num2str(TsikVPeepStringPercentError.(BigPath(z).name)) ])
            disp(['Tsik Vs Phee Error = ',       num2str(TsikVPheeErr.(BigPath(z).name)), ' %Error is ',num2str(TsikVPheePercentError.(BigPath(z).name)) ])
            disp(['Tsik Vs Trill Error = ',       num2str(TsikVTrillErr.(BigPath(z).name)), ' %Error is ',num2str(TsikVTrillPercentError.(BigPath(z).name)) ])
            disp(['Tsik Vs TsikString Error = ', num2str(TsikVTsikStringErr.(BigPath(z).name)), ' %Error is ',num2str(TsikVTsikStringPercentError.(BigPath(z).name)) ])
            disp(['Tsik Vs Twitter Error = ',    num2str(TsikVTwitterErr.(BigPath(z).name)), ' %Error is ',num2str(TsikVTwitterPercentError.(BigPath(z).name)) ])              
            %TsikString Results
            disp('                 TsikString Results                          ')
            disp(['TsikString Vs Peep Error = ',       num2str(TsikStringVPeepErr.(BigPath(z).name)), ' %Error is ',num2str(TsikStringVPeepPercentError.(BigPath(z).name)) ])
            disp(['TsikString Vs PeepString Error = ', num2str(TsikStringVPeepStringErr.(BigPath(z).name)), ' %Error is ',num2str(TsikStringVPeepStringPercentError.(BigPath(z).name)) ])
            disp(['TsikString Vs Phee Error = ',       num2str(TsikStringVPheeErr.(BigPath(z).name)), ' %Error is ',num2str(TsikStringVPheePercentError.(BigPath(z).name)) ])
            disp(['TsikString Vs Trill Error = ',      num2str(TsikStringVTrillErr.(BigPath(z).name)), ' %Error is ',num2str(TsikStringVTrillPercentError.(BigPath(z).name)) ])
            disp(['TsikString Vs Tsik Error = ',       num2str(TsikStringVTsikErr.(BigPath(z).name)), ' %Error is ',num2str(TsikStringVTsikPercentError.(BigPath(z).name)) ])
            disp(['TsikString Vs Twitter Error = ',    num2str(TsikStringVTwitterErr.(BigPath(z).name)), ' %Error is ',num2str(TsikStringVTwitterPercentError.(BigPath(z).name)) ])             
            %Twitter Results
            disp('                 Twitter Results                          ')
            disp(['Twitter Vs Peep Error = ',       num2str(TwitterVPeepErr.(BigPath(z).name)), ' %Error is ',num2str(TwitterVPeepPercentError.(BigPath(z).name)) ])
            disp(['Twitter Vs PeepString Error = ', num2str(TwitterVPeepStringErr.(BigPath(z).name)), ' %Error is ',num2str(TwitterVPeepStringPercentError.(BigPath(z).name)) ])
            disp(['Twitter Vs Phee Error = ',       num2str(TwitterVPheeErr.(BigPath(z).name)), ' %Error is ',num2str(TwitterVPheePercentError.(BigPath(z).name)) ])
            disp(['Twitter Vs Trill Error = ',      num2str(TwitterVTrillErr.(BigPath(z).name)), ' %Error is ',num2str(TwitterVTrillPercentError.(BigPath(z).name)) ])
            disp(['Twitter Vs Tsik Error = ',       num2str(TwitterVTsikErr.(BigPath(z).name)), ' %Error is ',num2str(TwitterVTsikPercentError.(BigPath(z).name)) ])
            disp(['Twitter Vs TsikString Error = ', num2str(TwitterVTsikStringErr.(BigPath(z).name)), ' %Error is ',num2str(TwitterVTsikStringPercentError.(BigPath(z).name)) ])     

% ------------------------------------------------------------------------%
%                        Generating output file                           %
% ------------------------------------------------------------------------% 
            fileName = strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:21),'.txt');
            fileID = fopen(fileName,'w');
            fprintf(fileID,'Number of mixtures = %i, %s\n', K(p), NormalizedTrainFolder(1).name(1:21));
            fprintf(fileID,'Just Finished %s_%i It had the following missclassification\n', BigPath(z).name,K(p));
            % Peep Results
            fprintf(fileID,' \nPeep Results\n');
            fprintf(fileID,'Peep Vs PeepString Error = %i/%i, Percent Error =%f  \n', PeepVPeepStringErr.(BigPath(z).name),length(peepNormFullTestData), PeepVPeepStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Peep Vs Phee       Error = %i/%i, Percent Error =%f  \n', PeepVPheeErr.(BigPath(z).name)      ,length(peepNormFullTestData), PeepVPheePercentError.(BigPath(z).name) );
            fprintf(fileID,'Peep Vs Trill      Error = %i/%i, Percent Error =%f  \n', PeepVTrillErr.(BigPath(z).name)     ,length(peepNormFullTestData), PeepVTrillPercentError.(BigPath(z).name) );
            fprintf(fileID,'Peep Vs Tsik       Error = %i/%i, Percent Error =%f  \n', PeepVTsikErr.(BigPath(z).name)      ,length(peepNormFullTestData), PeepVTsikPercentError.(BigPath(z).name) );
            fprintf(fileID,'Peep Vs TsikString Error = %i/%i, Percent Error =%f  \n', PeepVTsikStringErr.(BigPath(z).name),length(peepNormFullTestData), PeepVTsikStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Peep Vs Twitter    Error = %i/%i, Percent Error =%f  \n', PeepVTwitterErr.(BigPath(z).name)   ,length(peepNormFullTestData), PeepVTwitterPercentError.(BigPath(z).name) );
            % PeepString Results
            fprintf(fileID,' \nPeepString Results\n');
            fprintf(fileID,'PeepString Vs Peep       Error = %i/%i, Percent Error =%f  \n', PeepStringVPeepErr.(BigPath(z).name)      ,length(peepStringNormFullTestData), PeepStringVPeepPercentError.(BigPath(z).name) );
            fprintf(fileID,'PeepString Vs Phee       Error = %i/%i, Percent Error =%f  \n', PeepStringVPheeErr.(BigPath(z).name)      ,length(peepStringNormFullTestData), PeepStringVPheePercentError.(BigPath(z).name) );
            fprintf(fileID,'PeepString Vs Trill      Error = %i/%i, Percent Error =%f  \n', PeepStringVTrillErr.(BigPath(z).name)     ,length(peepStringNormFullTestData), PeepStringVTrillPercentError.(BigPath(z).name) );
            fprintf(fileID,'PeepString Vs Tsik       Error = %i/%i, Percent Error =%f  \n', PeepStringVTsikErr.(BigPath(z).name)      ,length(peepStringNormFullTestData), PeepStringVTsikPercentError.(BigPath(z).name) );
            fprintf(fileID,'PeepString Vs TsikString Error = %i/%i, Percent Error =%f  \n', PeepStringVTsikStringErr.(BigPath(z).name),length(peepStringNormFullTestData), PeepStringVTsikStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'PeepString Vs Twitter    Error = %i/%i, Percent Error =%f  \n', PeepStringVTwitterErr.(BigPath(z).name)   ,length(peepStringNormFullTestData), PeepStringVTwitterPercentError.(BigPath(z).name) );
            % Phee Results
            fprintf(fileID,' \nPhee Results\n');
            fprintf(fileID,'Phee Vs Peep       Error = %i/%i, Percent Error =%f  \n', PheeVPeepErr.(BigPath(z).name)      ,length(pheeNormFullTestData), PheeVPeepPercentError.(BigPath(z).name) );
            fprintf(fileID,'Phee Vs PeepString Error = %i/%i, Percent Error =%f  \n', PheeVPeepStringErr.(BigPath(z).name),length(pheeNormFullTestData), PheeVPeepStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Phee Vs Trill      Error = %i/%i, Percent Error =%f  \n', PheeVTrillErr.(BigPath(z).name)     ,length(pheeNormFullTestData), PheeVTrillPercentError.(BigPath(z).name) );
            fprintf(fileID,'Phee Vs Tsik       Error = %i/%i, Percent Error =%f  \n', PheeVTsikErr.(BigPath(z).name)      ,length(pheeNormFullTestData), PheeVTsikPercentError.(BigPath(z).name) );
            fprintf(fileID,'Phee Vs TsikString Error = %i/%i, Percent Error =%f  \n', PheeVTsikStringErr.(BigPath(z).name),length(pheeNormFullTestData), PheeVTsikStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Phee Vs Twitter    Error = %i/%i, Percent Error =%f  \n', PheeVTwitterErr.(BigPath(z).name)   ,length(pheeNormFullTestData), PheeVTwitterPercentError.(BigPath(z).name) );
            % Trill Results
            fprintf(fileID,' \nTrill Results\n');
            fprintf(fileID,'Trill Vs Peep       Error = %i/%i, Percent Error =%f  \n', TrillVPeepErr.(BigPath(z).name)      ,length(trillNormFullTestData), TrillVPeepPercentError.(BigPath(z).name) );
            fprintf(fileID,'Trill Vs PeepString Error = %i/%i, Percent Error =%f  \n', TrillVPeepStringErr.(BigPath(z).name),length(trillNormFullTestData), TrillVPeepStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Trill Vs Phee       Error = %i/%i, Percent Error =%f  \n', TrillVPheeErr.(BigPath(z).name)      ,length(trillNormFullTestData), TrillVPheePercentError.(BigPath(z).name) );
            fprintf(fileID,'Trill Vs Tsik       Error = %i/%i, Percent Error =%f  \n', TrillVTsikErr.(BigPath(z).name)      ,length(trillNormFullTestData), TrillVTsikPercentError.(BigPath(z).name) );
            fprintf(fileID,'Trill Vs TsikString Error = %i/%i, Percent Error =%f  \n', TrillVTsikStringErr.(BigPath(z).name),length(trillNormFullTestData), TrillVTsikStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Trill Vs Twitter    Error = %i/%i, Percent Error =%f  \n', TrillVTwitterErr.(BigPath(z).name)   ,length(trillNormFullTestData), TrillVTwitterPercentError.(BigPath(z).name) );
            % Tsik Results
            fprintf(fileID,' \nTsik Results\n');
            fprintf(fileID,'Tsik Vs Peep       Error = %i/%i, Percent Error =%f  \n', TsikVPeepErr.(BigPath(z).name)      ,length(tsikNormFullTestData), TsikVPeepPercentError.(BigPath(z).name) );
            fprintf(fileID,'Tsik Vs PeepString Error = %i/%i, Percent Error =%f  \n', TsikVPeepStringErr.(BigPath(z).name),length(tsikNormFullTestData), TsikVPeepStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Tsik Vs Phee       Error = %i/%i, Percent Error =%f  \n', TsikVPheeErr.(BigPath(z).name)      ,length(tsikNormFullTestData), TsikVPheePercentError.(BigPath(z).name) );
            fprintf(fileID,'Tsik Vs Trill      Error = %i/%i, Percent Error =%f  \n', TsikVTrillErr.(BigPath(z).name)     ,length(tsikNormFullTestData), TsikVTrillPercentError.(BigPath(z).name) );
            fprintf(fileID,'Tsik Vs TsikString Error = %i/%i, Percent Error =%f  \n', TsikVTsikStringErr.(BigPath(z).name),length(tsikNormFullTestData), TsikVTsikStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Tsik Vs Twitter    Error = %i/%i, Percent Error =%f  \n', TsikVTwitterErr.(BigPath(z).name)   ,length(tsikNormFullTestData), TsikVTwitterPercentError.(BigPath(z).name) );
            % TsikString Results
            fprintf(fileID,' \nTsikString Results\n');
            fprintf(fileID,'TsikString Vs Peep       Error = %i/%i, Percent Error =%f  \n', TsikStringVPeepErr.(BigPath(z).name)      ,length(tsikStringNormFullTestData), TsikStringVPeepPercentError.(BigPath(z).name) );
            fprintf(fileID,'TsikString Vs PeepString Error = %i/%i, Percent Error =%f  \n', TsikStringVPeepStringErr.(BigPath(z).name),length(tsikStringNormFullTestData), TsikStringVPeepStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'TsikString Vs Phee       Error = %i/%i, Percent Error =%f  \n', TsikStringVPheeErr.(BigPath(z).name)      ,length(tsikStringNormFullTestData), TsikStringVPheePercentError.(BigPath(z).name) );
            fprintf(fileID,'TsikString Vs Trill      Error = %i/%i, Percent Error =%f  \n', TsikStringVTrillErr.(BigPath(z).name)     ,length(tsikStringNormFullTestData), TsikStringVTrillPercentError.(BigPath(z).name) );
            fprintf(fileID,'TsikString Vs Tsik       Error = %i/%i, Percent Error =%f  \n', TsikStringVTsikErr.(BigPath(z).name)      ,length(tsikStringNormFullTestData), TsikStringVTsikPercentError.(BigPath(z).name) );
            fprintf(fileID,'TsikString Vs Twitter    Error = %i/%i, Percent Error =%f  \n', TsikStringVTwitterErr.(BigPath(z).name)   ,length(tsikStringNormFullTestData), TsikStringVTwitterPercentError.(BigPath(z).name) );
            % Twitter Results
            fprintf(fileID,' \nTwitter Results\n');
            fprintf(fileID,'Twitter Vs Peep       Error = %i/%i, Percent Error =%f  \n', TwitterVPeepErr.(BigPath(z).name)      ,length(twitterNormFullTestData), TwitterVPeepPercentError.(BigPath(z).name) );
            fprintf(fileID,'Twitter Vs PeepString Error = %i/%i, Percent Error =%f  \n', TwitterVPeepStringErr.(BigPath(z).name),length(twitterNormFullTestData), TwitterVPeepStringPercentError.(BigPath(z).name) );
            fprintf(fileID,'Twitter Vs Phee       Error = %i/%i, Percent Error =%f  \n', TwitterVPheeErr.(BigPath(z).name)      ,length(twitterNormFullTestData), TwitterVPheePercentError.(BigPath(z).name) );
            fprintf(fileID,'Twitter Vs Trill      Error = %i/%i, Percent Error =%f  \n', TwitterVTrillErr.(BigPath(z).name)     ,length(twitterNormFullTestData), TwitterVTrillPercentError.(BigPath(z).name) );
            fprintf(fileID,'Twitter Vs Tsik       Error = %i/%i, Percent Error =%f  \n', TwitterVTsikErr.(BigPath(z).name)      ,length(twitterNormFullTestData), TwitterVTsikPercentError.(BigPath(z).name) );
            fprintf(fileID,'Twitter Vs TsikString Error = %i/%i, Percent Error =%f  \n', TwitterVTsikStringErr.(BigPath(z).name),length(twitterNormFullTestData), TwitterVTsikStringPercentError.(BigPath(z).name) );            

            fclose(fileID);
% ------------------------------------------------------------------------%
%              Building Structure with all relavent info                  %
% ------------------------------------------------------------------------%         
            % Peep info
            Model.(BigPath(z).name).PeepVPeepStringErr = PeepVPeepStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepVPheeErr       = PeepVPheeErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepVTrillErr      = PeepVTrillErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepVTsikErr       = PeepVTsikErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepVTsikStringErr = PeepVTsikStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepVTwitterErr    = PeepVTwitterErr.(BigPath(z).name);
            % PeepString info
            Model.(BigPath(z).name).PeepStringVPeepErr       = PeepStringVPeepErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepStringVPheeErr       = PeepStringVPheeErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepStringVTrillErr      = PeepStringVTrillErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepStringVTsikErr       = PeepStringVTsikErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepStringVTsikStringErr = PeepStringVTsikStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).PeepStringVTwitterErr    = PeepStringVTwitterErr.(BigPath(z).name);
            % Phee info
            Model.(BigPath(z).name).PheeVPeepErr       = PheeVPeepErr.(BigPath(z).name);
            Model.(BigPath(z).name).PheeVPeepStingErr  = PheeVPeepStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).PheeVTrillErr      = PheeVTrillErr.(BigPath(z).name);
            Model.(BigPath(z).name).PheeVTsikErr       = PheeVTsikErr.(BigPath(z).name);
            Model.(BigPath(z).name).PheeVTsikStringErr = PheeVTsikStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).PheeVTwitterErr    = PheeVTwitterErr.(BigPath(z).name);
            % Trill info
            Model.(BigPath(z).name).TrillVPeepErr       = TrillVPeepErr.(BigPath(z).name);
            Model.(BigPath(z).name).TrillVPeepStingErr  = TrillVPeepStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).TrillVPheeErr       = TrillVPheeErr.(BigPath(z).name);
            Model.(BigPath(z).name).TrillVTsikErr       = TrillVTsikErr.(BigPath(z).name);
            Model.(BigPath(z).name).TrillVTsikStringErr = TrillVTsikStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).TrillVTwitterErr    = TrillVTwitterErr.(BigPath(z).name);
            % Tsik info
            Model.(BigPath(z).name).TsikVPeepErr       = TsikVPeepErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikVPeepStingErr  = TsikVPeepStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikVPheeErr       = TsikVPheeErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikVTrillErr      = TsikVTrillErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikVTsikStringErr = TsikVTsikStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikVTwitterErr    = TsikVTwitterErr.(BigPath(z).name);
            % TsikString info
            Model.(BigPath(z).name).TsikStringVPeepErr       = TsikStringVPeepErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikStringVPeepStingErr  = TsikStringVPeepStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikStringVPheeErr       = TsikStringVPheeErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikStringVTrillErr      = TsikStringVTrillErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikStringVTsikErr       = TsikStringVTsikErr.(BigPath(z).name);
            Model.(BigPath(z).name).TsikStringVTwitterErr    = TsikStringVTwitterErr.(BigPath(z).name);
            % Twitter info
            Model.(BigPath(z).name).TwitterVPeepErr       = TwitterVPeepErr.(BigPath(z).name);
            Model.(BigPath(z).name).TwitterVPeepStingErr  = TwitterVPeepStringErr.(BigPath(z).name);
            Model.(BigPath(z).name).TwitterVPheeErr       = TwitterVPheeErr.(BigPath(z).name);
            Model.(BigPath(z).name).TwitterVTrillErr      = TwitterVTrillErr.(BigPath(z).name);
            Model.(BigPath(z).name).TwitterVTsikErr       = TwitterVTsikErr.(BigPath(z).name);
            Model.(BigPath(z).name).TwitterVTsikStringErr = TwitterVTsikStringErr.(BigPath(z).name);           
% ------------------------------------------------------------------------%
%                     Save structure in a .mat file                       %
% ------------------------------------------------------------------------%          
            save(strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:21),'.mat'),'Model')
            save(strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:21),'_GMMModels.mat'),'GMM')
            %Clear out model for next pass
            clear Model
% ------------------------------------------------------------------------%
%                 This is a catch for failed GMM training                 %
% ________________________________________________________________________%
% If for what ever reason the training fails this will keep us moving     %
% forward.
% ------------------------------------------------------------------------% 
        catch exception
            fileName = strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:21),'.txt');
            fileID = fopen(fileName,'w');
            fprintf(fileID,'%s', 'This model has broken. Most likely due to the GMM failing to converge');
            fprintf(fileID,'\nERROR:\n%s', exception.message);
            fclose(fileID);
            disp('Starting next itteration on ')
        end      
    end
end
end
