% feature exctraction
function featureExtract()

addpath('Data')
addpath('NEEDED')

fs = 96000;
CallNames = {'peepCalls','peepStringCalls','comboCalls','tsikCalls', ...
    'tsikStringCalls','twitterCalls','pheeCalls','noVoiceCalls','trillCalls'};
windowSize = 0.025;
msTime = windowSize*10^3;
w = windowSize*fs;
l = floor(.4*w);

windowSizeList = [ 0.015, 0.025, 0.035, 0.045, 0.055, 0.065, 0.075, 0.085, 0.095, 0.105, 0.115, 0.125];
wlist = round(windowSizeList *fs);
mstimeList = windowSizeList * 10^3;
numCoeffsList = [ 12, 13 14, 15, 16, 17, 18, 19, 20];
numCoeffs = 12;


hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',fs);

for k = 1:length(numCoeffsList)
    for j = 1:length(windowSizeList)
        for i = 1:length(CallNames)
            waveFile = CallNames{i};
            
            waveIn1 = audioread(['NEEDED/filteredLabelledCalls/' waveFile '.wav']);
            waveIn2 = audioread(['NEEDED/filteredLabelledCalls/' waveFile '2.wav']);
            waveIn = [waveIn1;waveIn2];
            
            [coeffs,delta,deltaDelta] = mfcc(waveIn,fs,'WindowLength',wlist(j),'OverlapLength',l,'NumCoeffs',numCoeffsList(k));
            
            Features = [coeffs,delta,deltaDelta];
            
            % normalize the data
            normFeatures = zeros(size(Features));
            for i = 1:size(Features,2)
                mu(i) = mean(Features(:,i));
                sigma(i) = std(Features(:,i));
                normFeatures(:,i) = ((Features(:,i)-mu(i))./sigma(i));
            end
            if ~exist(strcat('NEEDED/MODEL',num2str(k),num2str(j),'/Normalized/'),'dir')
                mkdir(strcat('NEEDED/MODEL',num2str(k),num2str(j),'/Normalized/'));
            end
            if ~exist(strcat('NEEDED/MODEL',num2str(k),num2str(j),'/Regular/'),'dir')
                mkdir(strcat('NEEDED/MODEL',num2str(k),num2str(j),'/Regular/'));
            end
            save(strcat('NEEDED/MODEL',num2str(k),num2str(j),'/Normalized/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_FULL_', waveFile, '.mat'),'normFeatures')
            save(strcat('NEEDED/MODEL',num2str(k),num2str(j),'/Regular/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_FULL_', waveFile, '.mat'),'Features')
        end
    end
end

% c=1;
% numCoeffs = 20;
% CallNames = {'peepCalls','peepStringCalls','comboCalls','tsikCalls', ...
%     'tsikStringCalls','twitterCalls','pheeCalls','noVoiceCalls','trillCalls'};
% for i = length(CallNames)%1:length(CallNames)
%     waveFile = CallNames{i};
%     waveIn = audioread(strcat('NEEDED/filteredLabelledCalls/',waveFile ,'.wav'));
%
%
%     [coeffs,delta,deltaDelta] = mfcc(waveIn,fs,'WindowLength',w,'OverlapLength',l,'NumCoeffs',numCoeffs);
%
%     Features = [coeffs,delta,deltaDelta];
%
%     % normalize the data
%     % mu = load('totalMu.mat');
%     % sigma = load('totalSigma.mat');
%     % normFeatures = ((Features-mu.mu)./sigma.sigma);
%     save(['NEEDED/GMMFeatures/Features_20mfccs_' waveFile '_NonZScore.mat'],'Features')
%     c=1;
% end



