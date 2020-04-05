function featureVector =HPSFeatures(audioIn, W, Harm)

%--------------------------------------------------------
% This function takes an audio input saves off a feature
% set consisting of the Harmonic product spectrum done on a
% frame by frame basis
%------------------------------------

%Initialize Parameters
fs = 96000;
shift = W/2;
frameStart = 1;
frameStop = W;
frameIdx = 1;
w = hamming(W);


audioIn = audioIn(1:length(audioIn)); % in case custom samples are desired


%Initialize variables
HPS = zeros(length(audioIn),1);


while frameStop < length(audioIn)
    
    %Harmonic Product Sum
    Xwindowed = audioIn(frameStart:frameStop).*w;
    X1 = (fft(Xwindowed));
    
    XP_num = X1;
    
    if Harm > 1
        for i = 2:Harm
            XP_temp = decimate(X1,i);
            XP_num = XP_num.*[XP_temp;zeros(length(X1)-length(XP_temp),1)];
        end
    end
    
    HPS_Frame = XP_num;
    
    HPS(frameStart:frameStop) = HPS(frameStart:frameStop) + abs(HPS_Frame);
    
    %Shift window and increase index
    
    frameStart = frameStart + shift;
    frameStop = frameStop + shift;
    frameIdx = frameIdx + 1;
end

windowStart = 1;
windowEnd = W;
windowIdx = 1;
while windowEnd < length(HPS)

    featureVector(windowIdx,:) = HPS(windowStart:windowEnd);
        
    windowStart = windowStart + W;
    windowEnd = windowEnd + W;
    windowIdx = windowIdx + 1;
    
    
end

%save(['Features' '_HPS_' num2str(round(W*1000/fs)) 'msWindow_' num2str(Harm) 'Harmonics'],'featureVector','-v7.3')

