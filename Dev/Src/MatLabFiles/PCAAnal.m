%%Small script to analyze the PCA features between frames
addpath ('NEEDED/RegularizationTrainSpec');

Window1 = load('NEEDED/RegularizationTrainSpec/MODEL11/Features_waveFile_PcaExplained.mat');
window1Explain = Window1.explained;

Window2 = load('NEEDED/RegularizationTrainSpec/MODEL21/Features_waveFile_PcaExplained.mat');
window2Explain = Window2.explained;

Window3 = load('NEEDED/RegularizationTrainSpec/Model31/Features_waveFile_PcaExplained.mat');
window3Explain = Window3.explained;

Window4 = load('NEEDED/RegularizationTrainSpec/Model41/Features_waveFile_PcaExplained.mat');
window4Explain = Window4.explained;

c=1;
subplot(2,2,1)
plot(cumsum(window1Explain))
title('PCA percents by # of componets for window = 20 ms')

subplot(2,2,2)
plot(cumsum(window2Explain))
title('PCA percents by # of componets for window = 50 ms')

subplot(2,2,3)
plot(cumsum(window3Explain))
title('PCA percents by # of componets for window = 100 ms')

subplot(2,2,4)
plot(cumsum(window4Explain))
title('PCA percents by # of componets for window = 200 ms')