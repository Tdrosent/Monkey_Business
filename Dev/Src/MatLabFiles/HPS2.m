function HPS2(orig, W, thresh, N_cycles)

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

for i = 1:N_cycles
    %Initialize Parameters
    Fs = 96000;
    shift = W/2;
    frameStart = 1;
    frameStop = W;
    frameIdx = 1;
    w = hamming(W);
    
    %Read audio file
    samples = [460*Fs 475*Fs];
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
    HPS_Frame = HPS;
    X1 = [];
    X2 = [];
    X3 = [];
    X4 = [];
    
    while frameStop < length(in)
        
        %Harmonic Product Sum
        Xwindowed = in(frameStart:frameStop).*w;
        X1 = (abs(fft(Xwindowed))).^2;
        %X1 = (abs(fft(Xwindowed))).^2/length(in);
        
        %Declare R value
        R = 2;
        XP_num = X1;
        XP_den = upsample(X1,2);    
        XP_den = downsample(XP_den,3);
        
        for i = 2:R
            XP_temp = downsample(X1,i);
            XP_num = XP_num.*[XP_temp;zeros(length(X1)-length(XP_temp),1)];
            
            %Upsample then downsample to get half downsample intervals
            XP_temp2 = upsample(X1,2);
            XP_temp3 = downsample(XP_temp2,2*i+1);
            XP_temp4 = [XP_temp3;zeros((length(X1)-length(XP_temp3)), 1)];
            XP_den = XP_temp4.*[XP_den;zeros((length(X1)-length(XP_den)), 1)]; 
            
        end
        
        HPS_Frame(frameStart:frameStop) = XP_num./XP_den;
        HPS = HPS + HPS_Frame;
        HPS_Frame = HPS_Frame.*0;

        %Shift window and increase index
        frameStart = frameStart + shift;
        frameStop = frameStop + shift;
        frameIdx = frameIdx + 1;
    end
end

HPS(isnan(HPS)) = 0;
HPS_ifft = ifft(HPS);
%Plot spectrograms
spectrogram(in,W,W/2,Fs,'yaxis');
colormap(jet);
figure()
spectrogram(HPS_ifft,W,W/2,W,Fs,'yaxis');
colormap(jet);
