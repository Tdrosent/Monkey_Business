function HPS3(orig, W, Harm)

%--------------------------------------------------------
% This function takes an audio input and isolates the
% harmonics within it, the plots the following spectrums:
%  - The original spectrum
%  - The isolated harmonic spectrum
%------------------------------------
% INPUTS
% ~~~~~~~
% orig = Path to original .wav file
% W = Window size
% thresh = Threshold used in isolating harmonics
% N_cycles number of times to run through algorithm
%--------------------------------------------------------

%========================================================
% Method - Adjustable Window Size, Threshold, and Cycles
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
samples = [(0*60+3)*Fs (0*60+8)*Fs];
[in,fs] = audioread(orig,samples);

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

%Initialize variables
HPS = zeros(length(in),1);
HPS_Max = zeros(length(in),1);
HPS_Frame = zeros(W,1);
HPS_Frame_Max = zeros(W,1);

while frameStop < length(in)

    %Harmonic Product Sum
    Xwindowed = in(frameStart:frameStop).*w;
    X1 = (fft(Xwindowed));

    %Declare R value
    R = Harm;
    XP_num = X1;
    
    if R > 1
        for i = 2:R
            XP_temp = decimate(X1,i);
            XP_num = XP_num.*[XP_temp;zeros(length(X1)-length(XP_temp),1)];
        end
    end
    
    HPS_Frame = XP_num;
    [~, Max_Index] = max(HPS_Frame);
    if f(Max_Index) > freq_incr
        freq_min = f(Max_Index)-freq_incr;
        freq_max = f(Max_Index)+freq_incr;
    else
        freq_min = 1;
        freq_max = f(Max_Index)+freq_incr+1;
    end
    HPS_Frame_Max(round(freq_min):round(freq_max),:) = HPS_Frame_Max(round(freq_min):round(freq_max),:)+HPS_Frame(round(freq_min):round(freq_max),:);
    HPS_Frame = real(ifft(HPS_Frame));
    HPS_Frame_Max = real(ifft(HPS_Frame_Max));
    HPS(frameStart:frameStop) = HPS(frameStart:frameStop) + HPS_Frame;
    HPS_Max(frameStart:frameStop) = HPS_Max(frameStart:frameStop) + HPS_Frame_Max;
    
    HPS_Frame_Max = HPS_Frame_Max.*0;

    %Shift window and increase index
    frameStart = frameStart + shift;
    frameStop = frameStop + shift;
    frameIdx = frameIdx + 1;
end

% figure()
% HPS_Max_FFT = fft(HPS_Max);
% plot([1:length(HPS_Max_FFT)],real(HPS_Max_FFT));
    
%Plot spectrograms
% figure()
% spectrogram(in,W,W/2,Fs,'yaxis');
% colormap(jet);
figure()
spectrogram(HPS,W,W/2,Fs,'yaxis');
colormap(jet);
figure()
% [~,~,~,pxx,fc,tc] = spectrogram(HPS,W,W/2,W,Fs,'reassign','MinThreshold',-80,'yaxis');
spectrogram(HPS,W,W/2,W,Fs,'reassign','MinThreshold',-100,'yaxis');
colormap(jet);
figure()
[~,~,~,pxx,fc,tc] = spectrogram(HPS,W,W/2,W,Fs,'reassign','MinThreshold',-80,'yaxis');
%spectrogram(HPS,W,W/2,W,Fs,'MinThreshold',-100,'yaxis');
%colormap(jet);

figure()
plot(tc(pxx>0),fc(pxx>0),'.')
ylim([0, Fs/2]);
xlim([0, 5]);

% audiowrite('clean.wav',HPS,Fs)