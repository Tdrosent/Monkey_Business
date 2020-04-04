function HNRFeatures(audioIn,W)
%--------------------------------------------------------
% This function creates a VAD fatureset from the HNR
% value of each frame of input data and saves it out
%------------------------------------

[in,fs] = audioread(audioIn);


w = hamming(W);
hnr = harmonicRatio(in,fs,'Window',w,'OverlapLength',W/2);

save(['Features_HNR_' num2str(round(W*1000/fs)) 'msWindow'],'hnr','-v7.3')


