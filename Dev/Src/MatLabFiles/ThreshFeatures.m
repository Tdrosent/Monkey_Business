function ThreshFeatures(audioin, W)

%--------------------------------------------------------
%
%--------------------------------------------------------

%========================================================
%
%========================================================


%Initialize Parameters
Fs = 96000;
shift = W/2;
frameStart = 1;
frameStop = W;
frameIdx = 1;
w = kaiser(W, 12);
freq_incr = 300;

%Read audio file
[in,fs] = audioread(audioin);

f=Fs*(0:(length(in)/2))/length(in);

%Check to see if sampling frequency is correct
if Fs ~=fs
    Fs = fs;
end

%Turn the stereo audio to mono via averaging of the channels
in = mean(in, 2);

%HPF to omit LF noise
HPF = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',Fs);
in = filtfilt(HPF, in);

[~,~,~,pxx,fc,tc] = spectrogram(in,W,W/2,W,Fs,'reassign','MinThreshold',-80,'yaxis');

thresh = [tc(pxx>0),fc(pxx>0)];

save('Thresh','thresh')
