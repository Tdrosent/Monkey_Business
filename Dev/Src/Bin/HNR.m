% initialize parameters
windowSize  = 96000;
Fs          = 96000;
shift       = 125;
frameStart  = 1;
frameStop	= windowSize;
frameIdx    = 1;
hnrThresh   = 0.5;
w           = hamming(windowSize);

% make directories if they don't exist
if ~exist('../../../Data/Results')
    mkdir('../../../Data/Results')
end
   
% decalre datapath and file name
dataPath = '../../../Data/SeperatedData/Testing';
resultsPath = '../../../Data/Results/';
fileName = 'peepCallsTest006.wav';

% read audio signal
[audioIn,fs]= audioread(strcat(dataPath,'/',fileName));

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

audiowrite(strcat(resultsPath,'HarmonicOutput.wav'),harmonicSignal,Fs)