function [FeatureVec]=getPSDFeatures(signal, windowSize, Olap)
win = window(@hann, windowSize);
NumFrames = ceil(length(signal)/windowSize+(Olap/windowSize)*length(signal)/windowSize);
blkStart = 1;
blkEnd = windowSize;
FeatureVec = zeros(NumFrames,ceil(windowSize/2));
for p = 1:NumFrames
    tempSignal = fft(signal(blkStart:blkEnd).*win);
    FeatureVec(p,:)=abs(tempSignal(1:ceil(end/2))).^2;
    blkStart = blkStart + Olap;
    blkEnd = blkEnd + Olap;
end
end