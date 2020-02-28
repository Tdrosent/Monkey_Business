function HPS2(orig, W, Harm)

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
w = kaiser(W, 15);
%     w = hamming(W);

%Read audio file
samples = [(27*60+27)*Fs (27*60+31)*Fs];
[in,fs] = audioread(orig,samples);

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
HPS_Frame = zeros(W,1);

while frameStop < length(in)

    %Harmonic Product Sum
%         Xwindowed = filtfilt(LPF, in(frameStart:frameStop));
    Xwindowed = in(frameStart:frameStop).*w;
    X1 = (fft(Xwindowed));
    %X1 = (abs(fft(Xwindowed))).^2/length(in);

    %Declare R value
    R = Harm;
    XP_num = X1;
    XP_den = upsample(X1,2);    
    XP_den = downsample(XP_den,3);
    if R > 1
        for i = 2:R
            XP_temp = decimate(X1,i);
            XP_num = XP_num.*[XP_temp;zeros(length(X1)-length(XP_temp),1)];
%                 XP_num(XP_num == min(XP_num(:))) = 1e-12;
%                 XP_num = XP_num./transpose(circshift(transpose(XP_num),W/2));
%                 XP_num = XP_num./transpose(circshift(transpose(XP_num),W/4));

%             %Upsample then downsample to get half downsample intervals
%             XP_temp2 = upsample(X1,2);
%             XP_temp3 = downsample(XP_temp2,2*i+1);
%             XP_temp4 = [XP_temp3;zeros((length(X1)-length(XP_temp3)), 1)];
%             XP_den = XP_temp4.*[XP_den;zeros((length(X1)-length(XP_den)), 1)]; 

        end
    end
%         HPS_Frame(HPS_Frame < 0.9*max(HPS_Frame(:))) = 0;
    HPS_Frame = real(ifft(XP_num));%./XP_den);
%         HPS_Frame(HPS_Frame < 0.5*max(HPS_Frame(:))) = 0;
    HPS(frameStart:frameStop) = HPS(frameStart:frameStop) + HPS_Frame;
%         HPS_Frame = HPS_Frame*0;

    %Shift window and increase index
    frameStart = frameStart + shift;
    frameStop = frameStop + shift;
    frameIdx = frameIdx + 1;
end

% LPF= designfilt('lowpassiir','FilterOrder',8, 'PassbandFrequency',5000,'PassbandRipple',0.2, 'SampleRate',Fs);
in_FFT = real(fft(in));
HPS_FFT = real(fft(HPS));


% HPS = abs(HPS);

% t = 1:length(in);
% HPS = filtfilt(LPF, HPS);
% HPS(isinf(HPS)) = max(HPS);
% HPS(isnan(HPS)) = 0;
% HPS_ifft = idct(HPS);
% HPS_ifft = HPS_ifft/max(HPS_ifft);

%Plot spectrograms
spectrogram(in,W,W/2,Fs,'yaxis');
colormap(jet);
figure()
spectrogram(HPS,W,W/2,Fs,'yaxis');
colormap(jet);

% figure()
% plot(t, in_FFT)
% xlim([0, 4000])
% % ylim([0, 1400])
% figure()
% plot(t, HPS_FFT)
% xlim([0, length(in)/2])
% % ylim([0, 6000])