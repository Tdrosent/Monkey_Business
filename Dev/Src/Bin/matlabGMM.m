

clear
% clc
addpath(genpath('NEEDED'))


% load in normalized mfcc features


% 
% noVoice = load('Features_12mfccs_20ms_FULL_noVoiceCalls.mat');
% noVoice = noVoice.normFeatures(:,:);
% cv = cvpartition(size(noVoice,1),'HoldOut',0.20);
% indxnoVoice = cv.test;
% noVoiceTrain = noVoice(~indxnoVoice,:);
% noVoiceTest = noVoice(indxnoVoice,:);
% 
% twitter = load('Features_12mfccs_15ms_FULL_twitterCalls.mat');
% twitter = twitter.normFeatures(:,:);
% cv = cvpartition(size(twitter,1),'HoldOut',0.20);
% indxtwitter = cv.test;
% twitterTrain = twitter(~indxtwitter,:);
% twitterTest = twitter(indxtwitter,:);

trill = load('NORMALIZED_Features_12mfccs_25ms_trill.mat');
trill = trill.Features2(:,:);
cv = cvpartition(size(trill,1),'HoldOut',0.20);
indxtrill = cv.test;
trillTrain = trill(~indxtrill,:);
trillTest = trill(indxtrill,:);

phee = load('NORMALIZED_Features_12mfccs_25ms_Phee.mat');
phee = phee.Features1(:,:);
cv = cvpartition(size(phee,1),'HoldOut',0.20);
indxphee = cv.test;
pheeTrain = phee(~indxphee,:);
pheeTest = phee(indxphee,:);

% Train GMM models

% GMMcombo      = fitgmdist(combo,8,      'CovarianceType','diagonal','Options',statset('Display','iter','MaxIter',250));
% GMMpeep       = fitgmdist(peep,8,       'CovarianceType','diagonal','Options',statset('Display','iter','MaxIter',250));
% GMMpeepString = fitgmdist(peepString,8, 'CovarianceType','diagonal','Options',statset('Display','iter','MaxIter',250));
% GMMtsik       = fitgmdist(tsik,8,       'CovarianceType','diagonal','Options',statset('Display','iter','MaxIter',250));
% % GMMtsikString = fitgmdist(tsikString,8, 'CovarianceType','diagonal','Options',statset('Display','iter','MaxIter',250));
% GMMnoVoice    = fitgmdist(noVoice,8,         'Replicates',5,'Options',statset('Display','iter','MaxIter',250));
% GMMtwitter    = fitgmdist(twitterTrain,8,    'Replicates',5,'Options',statset('Display','iter','MaxIter',250));
GMMtrill      = fitgmdist(trillTrain,8,      'Replicates',2,'Options',statset('Display','iter','MaxIter',250));
GMMphee       = fitgmdist(pheeTrain,8,       'Replicates',2,'Options',statset('Display','iter','MaxIter',250));

% Evaluated pdfs on trained models
% twitterTrainingErrors = 0;
trillTrainingErrors   = 0;
pheeTrainingErrors    = 0;
% twitterTestingErrors = 0;
trillTestingErrors   = 0;
pheeTestingErrors    = 0;

% Evaluate the GMMs

% 1. Trill - training
trill_GMMtrillTrain   = pdf(GMMtrill,trillTrain);
trill_GMMpheeTrain    = pdf(GMMphee,trillTrain);

% count errors
for i = 1:length(trill_GMMtrillTrain)
    if trill_GMMtrillTrain(i) < trill_GMMpheeTrain(i)
    
        trillTrainingErrors = trillTrainingErrors + 1;
        
    end
end
trillTrainError = trillTrainingErrors/length(trill_GMMtrillTrain);
disp('Displaying Training results for Trill call: ')
disp('')
disp(['Number of mis-classified frames = ' num2str(trillTrainingErrors) ' for a total of '...
    num2str(length(trill_GMMtrillTrain)) ' frames. '])
disp(['Error percentage = ' num2str(100*trillTrainError) ' %'])
% 1. Trill - testing
trill_GMMtrillTest   = pdf(GMMtrill,trillTest);
trill_GMMpheeTest    = pdf(GMMphee,trillTest);

% count errors
for i = 1:length(trill_GMMtrillTest)
    if trill_GMMtrillTest(i) < trill_GMMpheeTest(i)
    
        trillTestingErrors = trillTestingErrors + 1;
        
    end
end
trillTestError = trillTestingErrors/length(trill_GMMtrillTest);
disp('Displaying Testing results for Trill call: ')
disp('')
disp(['Number of mis-classified frames = ' num2str(trillTestingErrors) ' for a total of '...
    num2str(length(trill_GMMtrillTest)) ' frames. '])
disp(['Error percentage = ' num2str(100*trillTestError) ' %'])
%%
% 2. Phee - training
phee_GMMtrillTrain   = pdf(GMMtrill,pheeTrain);
phee_GMMpheeTrain    = pdf(GMMphee,pheeTrain);

% count errors
for i = 1:length(phee_GMMpheeTrain)
    if phee_GMMpheeTrain(i) < phee_GMMtrillTrain(i)
    
        pheeTrainingErrors = pheeTrainingErrors + 1;
        
    end
end
pheeTrainError = pheeTrainingErrors/length(phee_GMMpheeTrain);
disp('Displaying Training results for Phee call: ')
disp('')
disp(['Number of mis-classified frames = ' num2str(pheeTrainingErrors) ' for a total of '...
    num2str(length(phee_GMMpheeTrain)) ' frames. '])
disp(['Error percentage = ' num2str(100*pheeTrainError) ' %'])
% 2. phee - testing
phee_GMMtrillTest   = pdf(GMMtrill,pheeTest);
phee_GMMpheeTest    = pdf(GMMphee,pheeTest);

% count errors
for i = 1:length(phee_GMMpheeTest)
    if phee_GMMpheeTest(i) < phee_GMMtrillTest(i)
    
        pheeTestingErrors = pheeTestingErrors + 1;
        
    end
end
pheeTestError = pheeTestingErrors/length(phee_GMMpheeTest);
disp('Displaying Testing results for Phee call: ')
disp('')
disp(['Number of mis-classified frames = ' num2str(pheeTestingErrors) ' for a total of '...
    num2str(length(phee_GMMpheeTest)) ' frames. '])
disp(['Error percentage = ' num2str(100*pheeTestError) ' %'])
