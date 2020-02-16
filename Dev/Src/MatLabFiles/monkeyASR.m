function [] = monkeyASR(windowSize,overlap,inputData,Fs)

addpath('../Data')
addpath('../Models')

%load normalization structure
normalize = load('../Test/NormalizationStruct.mat');
stateSequence = load('StateSequence_windowSize_25ms.mat');
GMMk = 8;

if ~exist('windowSize','var')
    windowSize = 0.025*96000;
end
if ~exist('inputData','var')
    [inputData1,Fs] = audioread('Data/STE-010-Train.wav');
    [inputData2,Fs] = audioread('Data/STE-063-Train.wav');
    
end
inputData = [inputData1; inputData2];
if ~exist('overlap','var')
    overlap = 0.4;
end

l = floor(overlap*windowSize);
numCoeffs = 12;
numVocalizations = 9;

GMMModel = {};
% Reorganize GMM model order to match that of the HMM encoding

% GMM model order [combo peep peepString phee trill tsik tsikString twitter nonVoiced]
% HMM model order [nonVoiced peep peepString phee trill tsik tsikString twitter combo]
% HMM encoding matches the call index in the above array

GMMModels = load('GMMModel8NoSharedCovariance.mat');
GMMModel{1} = GMMModels.GMMModel{9};
GMMModel{2} = GMMModels.GMMModel{2};
GMMModel{3} = GMMModels.GMMModel{3};
GMMModel{4} = GMMModels.GMMModel{4};
GMMModel{5} = GMMModels.GMMModel{5};
GMMModel{6} = GMMModels.GMMModel{6};
GMMModel{7} = GMMModels.GMMModel{7};
GMMModel{8} = GMMModels.GMMModel{8};
GMMModel{9} = GMMModels.GMMModel{1};

posteriorProbs = zeros(numVocalizations,GMMk);
pdfProb = zeros(numVocalizations,1);

% High pass filter to remove LF noise
hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',Fs);
HPFData = filtfilt(hpFilt,inputData);
AvergedHPFCall = 1/2*(HPFData(:,1)+HPFData(:,2));
[coeffs,delta,deltaDelta] = mfcc(AvergedHPFCall,Fs,'WindowLength',windowSize,'OverlapLength',l,'NumCoeffs',numCoeffs);
features = [coeffs,delta,deltaDelta];


% normalize the data according to training data statistics (Z-score)

meanVector = normalize.NormalizationSturct.Mean;
stdVector = normalize.NormalizationSturct.std;
emissionProbTraining = zeros(numVocalizations,size(features,1));
for k = 1:length(features)
    features(k,:) = (features(k,:)-meanVector)./stdVector;
end

pdfProbs = zeros(size(features,1),1);
% pass the features frame by frame throught the GMM-HMM solution

for i = 1:size(features,1)
   
    % obtain a the emission probability from each GMM (1 per vocalization, 9 total)
    for j = 1:numVocalizations
%         [posteriorProbs(j,:),nLogl(j)] = posterior(GMMModel{j},features(i,:));
        [pdfProb(i,j)] = pdf(GMMModel{j},features(i,:));
    end
%     pdfProbs(i) = find(max(pdfProb(i,:))==pdfProb(i,:));
%     callLikelihood(i,:) = find(max(nLogl)==nLogl);
end

% create initial guess for transition matrix
TransGuess = ones(numVocalizations).*(1/(numVocalizations^2));
% create emissions sequence
seq = 1:1:length(features);


% train HMM
[TRANS_EST, EMIS_EST] = hmmtrain(seq, TransGuess, pdfProb');


save('TransEst.mat','TRANS_EST');
save('EmisEst.mat','EMIS_EST');


seq = pdfProbs(1);
decision = [];
Trans = load('HMMTransProbs_windowSize_25ms.mat');
Trans = (Trans.TRANS_EST);
for i = 1:size(features,1)
    seq = [seq decision];
    [PSTATES,logpseq] = hmmdecode(seq,Trans,diag(pdfProb(i,:)));
    decision = find(max(PSTATES(:,i))==PSTATES(:,i));
    
end
end