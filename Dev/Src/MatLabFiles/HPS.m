% initialize parameters
windowSize  = 4096;
Fs          = 96000;
shift       = 4096/2;
frameStart  = 1;
frameStop	= windowSize;
frameIdx    = 1;
hnrThresh   = 0.3;
w           = hamming(windowSize);
% read audio signal
samples = [460*Fs 475*Fs];
[audioIn,fs]= audioread('STE-063.wav',samples);

% average both channels
audioIn = mean(audioIn,2);

% high-pass filter the audio to remove LF noise
hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',Fs);
audioIn = filtfilt(hpFilt,audioIn);

% plot the spectrogram
spectrogram(audioIn,windowSize,windowSize/2,4096,Fs,'yaxis');
colormap(jet);

% initialize the output signal
harmonicSignal = [];

X1 = [];
X2 = [];
X3 = [];
X4 = [];

while frameStop < length(audioIn)
    
    % Harmonic Product Spectrum
    Xwindowed = audioIn(frameStart:frameStop).*w;
    X1 = abs(fft(Xwindowed));
    X2 = downsample(X1,2);
    X3 = downsample(X1,3);
    X4 = downsample(X1,4);
    
    XP = X1.*[X2;zeros(length(X1)-length(X2),1)].*[X3;zeros(length(X1)-length(X3),1)].*[X4;zeros(length(X1)-length(X4),1)];
    
    HP(frameStart:frameStop) = (ifft(XP));
    
    % HNR threshold operation
    %     hnr = harmonicRatio(audioIn(frameStart:frameStop),fs);
    %
    %     if hnr > hnrThresh
    %         harmonicSignal = [harmonicSignal; audioIn(frameStart:frameStop)]; %#ok<AGROW>
    %     end
    
    % increment counters
    frameStart = frameStart + shift;
    frameStop = frameStop + shift;
    frameIdx = frameIdx +1;
end
figure()

spectrogram(HP,windowSize,windowSize/2,4096,Fs,'yaxis');


% write out harmonic signal output

% audiowrite('HarmonicOutput.wav',harmonicSignal,Fs)