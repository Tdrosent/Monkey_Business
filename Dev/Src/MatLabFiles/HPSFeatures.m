function HPSFeatures(audioIn, W, Harm)

%--------------------------------------------------------
% This function takes an audio input saves off a feature
% set consisting of the Harmonic product spectrum done on a
% frame by frame basis
%------------------------------------

%Initialize Parameters
shift = W/2;
frameStart = 1;
frameStop = W;
frameIdx = 1;
w = hamming(W);

[in,fs] = audioread(audioIn);

in = in(1:length(in)); % in case custom samples are desired


%Initialize variables
HPS = zeros(length(in),1);


while frameStop < length(in)
    
    %Harmonic Product Sum
    Xwindowed = in(frameStart:frameStop).*w;
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

save(['Features' '_HPS_' num2str(round(W*1000/fs)) 'msWindow_' num2str(Harm) 'Harmonics'],'featureVector','-v7.3')

