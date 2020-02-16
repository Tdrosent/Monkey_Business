% feature exctraction
function featureExtract()

addpath('Data')
addpath('NEEDED')

fs = 96000;

windowSize = 0.025;
w = windowSize*fs;
l = floor(.4*w);
numCoeffs = 12;

hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',fs);

 waveFile1 = 'pheeCalls';
 waveFile2 = 'trillCalls';

% waveIn1 = audioread(['NEEDED/STE-010.wav']);
% HPFSTE010= filtfilt(hpFilt,waveIn1);
% AvergedHPFSTE010 = 1/2*(HPFSTE010(:,1)+HPFSTE010(:,2));
% waveIn2 = audioread(['NEEDED/STE-063.wav']);
% HPFSTE063= filtfilt(hpFilt,waveIn2);
% AvergedHPFSTE063 = 1/2*(HPFSTE063(:,1)+HPFSTE063(:,2));
waveIn1 = audioread(['NEEDED/filteredLabelledCalls/' waveFile1 '.wav']);
waveIn1 = [waveIn1 ; audioread(['NEEDED/filteredLabelledCalls/' waveFile1 '2.wav'])];
waveIn2 = audioread(['NEEDED/filteredLabelledCalls/' waveFile2 '.wav']);
waveIn2 = [waveIn2 ; audioread(['NEEDED/filteredLabelledCalls/' waveFile2 '2.wav'])];

waveIn = [waveIn1;waveIn2];

[coeffs1,delta1,deltaDelta1] = mfcc(waveIn1,fs,'WindowLength',w,'OverlapLength',l,'NumCoeffs',numCoeffs);

Features1 = [coeffs1,delta1,deltaDelta1];

[coeffs2,delta2,deltaDelta2] = mfcc(waveIn2,fs,'WindowLength',w,'OverlapLength',l,'NumCoeffs',numCoeffs);

Features2 = [coeffs2,delta2,deltaDelta2];
% normalize the data
% normFeatures = zeros(size(Features));
% for i = 1:size(Features,2)
%     mu(i) = mean(Features(:,i));
%     sigma(i) = std(Features(:,i));
%     normFeatures(:,i) = ((Features(:,i)-mu(i))./sigma(i));
% end
mu = load('C:\GitHub\SHS598_Project\NEEDED\VADModels\mu.mat');
sigma = load('C:\GitHub\SHS598_Project\NEEDED\VADModels\sigma.mat');

Features1 = (Features1-mu.mu)./sigma.sigma;
Features2 = (Features2-mu.mu)./sigma.sigma;
save(['NEEDED/NORMALIZED_Features_12mfccs_25ms_Phee.mat'],'Features1')
save(['NEEDED/NORMALIZED_Features_12mfccs_25ms_trill.mat'],'Features2')

% save(['NEEDED/Full_mu_' waveFile '.mat'],'mu')
% save(['NEEDED/Full_sigma_' waveFile '.mat'],'sigma')

c=1;



