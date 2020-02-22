% initialize parameters
windowSize  = 96000;
Fs          = 96000;
shift       = 125;
frameStart  = 1;
frameStop	= windowSize;
frameIdx    = 1;
hnrThresh   = 0.6;
w           = hamming(windowSize);

% read audio signal
[audioIn,fs]= audioread('STE-063.wav');

% average both channels
audioIn = mean(audioIn,2);

% high-pass filter the audio to remove LF noise
hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',Fs);       
audioIn = filtfilt(hpFilt,audioIn);

% plot the spectrogram
spectrogram(audioIn,windowSize,windowSize/2,2048,Fs,'yaxis');
colormap(jet);

% initialize the output signal
harmonicSignal = [];

while frameStop < length(audioIn)
    
    
    hnr = harmonicRatio(audioIn(frameStart:frameStop),fs);
    
    if hnr > hnrThresh
        harmonicSignal = [harmonicSignal; audioIn(frameStart:frameStop)]; %#ok<AGROW>
    end
    
    % increment counters
    frameStart = frameStart + windowSize;
    frameStop = frameStop + windowSize;
    frameIdx = frameIdx +1;  
end

% write out harmonic signal output

audiowrite('HarmonicOutput.wav',harmonicSignal,Fs)