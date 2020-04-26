function MulitipleGMMVADTest()
clear
clc

path1 = '../../../Data/FeaturesVAD/Training/';
path2 = '../../../Data/FeaturesVAD/Testing/';
path3 = '../../../Data/TestingResultsVAD/';
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
%                     Loading in UnVoiced Data                            %
% ------------------------------------------------------------------------%
        UnVoiced = load(NormalizedTrainCallsName{1});
        UnVoicedNormFullTrainData = UnVoiced.TrainNormFeaturesUnVoiced(:,:);
        UnVoicedNormFullTrainData(isinf(abs(UnVoicedNormFullTrainData))) = NaN;
        
        UnVoicedTest = load(NormalizedTestCallsName{1});
        UnVoicedNormFullTestData = UnVoicedTest.TestNormFeaturesUnVoiced(:,:);
        UnVoicedNormFullTestData(isinf(abs(UnVoicedNormFullTestData))) = NaN;
        
        Call.UnVoiced.NormFullTrainData = UnVoicedNormFullTrainData;
        Call.UnVoiced.NormFullTestData  = UnVoicedNormFullTestData;
        %Initialize Variable to count Errors
        PredictedUnVoiced1 = [];
% ------------------------------------------------------------------------%
%                      Loading in Voiced Data                             %
% ------------------------------------------------------------------------%
        Voiced = load(NormalizedTrainCallsName{2});
        VoicedNormFullTrainData = Voiced.TrainNormFeaturesVoiced(:,:);
        VoicedNormFullTrainData(isinf(abs(VoicedNormFullTrainData))) = NaN;
        
        VoicedTest = load(NormalizedTestCallsName{2});
        VoicedNormFullTestData = VoicedTest.TestNormFeaturesVoiced(:,:);
        VoicedNormFullTestData(isinf(abs(VoicedNormFullTestData))) = NaN;
        
        Call.Voiced.NormFullTrainData = VoicedNormFullTrainData;
        Call.Voiced.NormFullTestData  = VoicedNormFullTestData;
        %Initialize Variable to count Errors
        PredictedVoiced1 = [];
        
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
        
        % Voiced
        VoicedVUnVoicedErr.(BigPath(z).name)=0;
        %UnVoiced
        UnVoicedVVoicedErr.(BigPath(z).name)=0;
       
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
%                          Evaluating unVoiced GMM's                      %
% ------------------------------------------------------------------------%
            %Peep Vs PeepString
            PredictedUnVoiced1(:,1) = pdf(GMM.UnVoiced ,Call.UnVoiced.NormFullTestData);
            PredictedUnVoiced1(:,2) = pdf(GMM.Voiced   ,Call.UnVoiced.NormFullTestData);
            for j = 1:length(PredictedUnVoiced1)
                if PredictedUnVoiced1(j,1) < PredictedUnVoiced1(j,2)
                    UnVoicedVVoicedErr.(BigPath(z).name) = UnVoicedVVoicedErr.(BigPath(z).name) +1;
                end
            end
            UnVoicedVVoicedPercentError.(BigPath(z).name) = UnVoicedVVoicedErr.(BigPath(z).name)/length(PredictedUnVoiced1)*100;
            
% ------------------------------------------------------------------------%
%                          Evaluating Voiced GMM's                      %
% ------------------------------------------------------------------------%
            %Peep Vs PeepString
            PredictedVoiced1(:,1) = pdf(GMM.Voiced   ,Call.Voiced.NormFullTestData);
            PredictedVoiced1(:,2) = pdf(GMM.UnVoiced ,Call.Voiced.NormFullTestData);
            for j = 1:length(PredictedVoiced1)
                if PredictedVoiced1(j,1) < PredictedVoiced1(j,2)
                    VoicedVUnVoicedErr.(BigPath(z).name) = VoicedVUnVoicedErr.(BigPath(z).name) +1;
                end
            end
            VoicedVUnVoicedPercentError.(BigPath(z).name) = VoicedVUnVoicedErr.(BigPath(z).name)/length(PredictedVoiced1)*100;
            
          

% ------------------------------------------------------------------------%
% !!!!!!!!!!!!!!!!!!!!!!!!!END OF EVALUATION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% ------------------------------------------------------------------------%
            
% ------------------------------------------------------------------------%
%                  Print Results out to Command Window                    %
% ------------------------------------------------------------------------%            
            
            disp(['Just Finished ', BigPath(z).name, ' It had the following missclassification'])
            disp(' ')
            % unVoiced Results
            disp('                 unVoiced Results                         ')
            disp(['UnVoiced Vs voiced Error = ', num2str(VoicedVUnVoicedErr.(BigPath(z).name)), ' %Error is ',num2str(UnVoicedVVoicedPercentError.(BigPath(z).name)) ])
            
            disp('                 Voiced Results                         ')
            disp(['Voiced Vs UnVoiced Error = ', num2str(UnVoicedVVoicedErr.(BigPath(z).name)), ' %Error is ',num2str(VoicedVUnVoicedPercentError.(BigPath(z).name)) ])   

% ------------------------------------------------------------------------%
%                        Generating output file                           %
% ------------------------------------------------------------------------% 
            fileName = strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:17),'.txt');
            fileID = fopen(fileName,'w');
            fprintf(fileID,'Number of mixtures = %i, %s\n', K(p), NormalizedTrainFolder(1).name(1:17));
            fprintf(fileID,'Just Finished %s_%i It had the following missclassification\n', BigPath(z).name,K(p));
            % UnVoiced Results
            fprintf(fileID,' \nUnVoiced Results\n');
            fprintf(fileID,'UnVoiced Vs Voiced Error = %i/%i, Percent Error =%f  \n', UnVoicedVVoicedErr.(BigPath(z).name),length(UnVoicedNormFullTestData), UnVoicedVVoicedPercentError.(BigPath(z).name) );
            % Voiced Results
            fprintf(fileID,' \nVoiced Results\n');
            fprintf(fileID,'Voiced Vs UnVoiced Error = %i/%i, Percent Error =%f  \n', VoicedVUnVoicedErr.(BigPath(z).name),length(VoicedNormFullTestData), VoicedVUnVoicedPercentError.(BigPath(z).name) );

            fclose(fileID);
% ------------------------------------------------------------------------%
%              Building Structure with all relavent info                  %
% ------------------------------------------------------------------------%         
            % unVoiced info
            Model.(BigPath(z).name).UnVoicedVVoicedErr = UnVoicedVVoicedErr.(BigPath(z).name);
            % Voiced info
            Model.(BigPath(z).name).VoicedVUnVoicedErr = VoicedVUnVoicedErr.(BigPath(z).name);

% ------------------------------------------------------------------------%
%                     Save structure in a .mat file                       %
% ------------------------------------------------------------------------%          
            save(strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:17),'.mat'),'Model')
            save(strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:17),'_GMMModels.mat'),'GMM')
            %Clear out model for next pass
            clear Model
% ------------------------------------------------------------------------%
%                 This is a catch for failed GMM training                 %
% ________________________________________________________________________%
% If for what ever reason the training fails this will keep us moving     %
% forward.
% ------------------------------------------------------------------------% 
        catch exception
            fileName = strcat(path3,'/',BigPath(z).name,'_',num2str(K(p)),'_Mixtures_',NormalizedTrainFolder(1).name(10:17),'.txt');
            fileID = fopen(fileName,'w');
            fprintf(fileID,'%s', 'This model has broken. Most likely due to the GMM failing to converge');
            fprintf(fileID,'\nERROR:\n%s', exception.message);
            fclose(fileID);
            disp('Starting next itteration on ')
        end      
    end
end
end
