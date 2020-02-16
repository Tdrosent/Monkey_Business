addpath('Data')
addpath('NEEDED')

fs = 96000;
CallNames = {'twitterCalls','pheeCalls','trillCalls'};

Twitter1 = audioread(['NEEDED/Training/twitterCallsTrain.wav']);
Twitter2 = audioread(['NEEDED/Training/twitterCallsTrain2.wav']);
PheeCalls1 = audioread(['NEEDED/Training/pheeCallsTrain.wav']);
PheeCalls2 = audioread(['NEEDED/Training/pheeCallsTrain2.wav']);
TrillCalls1 = audioread(['NEEDED/Training/trillCallsTrain.wav']);
TrillCalls2 = audioread(['NEEDED/Training/trillCallsTrain2.wav']);


FullData = [Twitter1;Twitter2;PheeCalls1;PheeCalls2;TrillCalls1;TrillCalls2];

windowSizeList = [ 0.02, 0.05, 0.1, 0.2];
% windowSizeList = [ 0.01, 0.025, 0.075, 0.105, 0.250, .750, 1];
wlist = round(windowSizeList *fs);
l = floor(.4.*wlist);
mstimeList = windowSizeList * 10^3;
numCoeffsList = [12];

for k = 1:length(numCoeffsList)
    for j = 1:length(windowSizeList)
        %Dynamically computing z-score Normalization factors
        [coeffsFull,deltaFull,deltaDeltaFull] = mfcc(FullData,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
        FullFeatures = [coeffsFull,deltaFull,deltaDeltaFull];
        mu = mean(FullFeatures);
        sigma = std(FullFeatures);
        NormalizationFactor.mu = mu;
        NormalizationFactor.sigma=sigma;
        if ~exist(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k)),'dir')
                mkdir(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k)));
        end
        save(strcat('NEEDED/ModelsTrain/MODEL',num2str(j),num2str(k),'/Features_',num2str(numCoeffsList(k)),'mfccs_',num2str(mstimeList(j)),'ms_NormalizationFactors.mat'),'NormalizationFactor')
        for i = 1:length(CallNames)

            waveFile = CallNames{1};
            
            TrainwaveIn1 = audioread(['NEEDED/Training/' waveFile 'Train.wav']);
            TrainwaveIn2 = audioread(['NEEDED/Training/' waveFile 'Train2.wav']);
            TrainwaveIn = [TrainwaveIn1;TrainwaveIn2];
            
            TestwaveIn1 = audioread(['NEEDED/Testing/' waveFile 'Test.wav']);
            TestwaveIn2 = audioread(['NEEDED/Testing/' waveFile 'Test2.wav']);
            TestwaveIn = [TestwaveIn1;TestwaveIn2];
            
            [coeffsTrain,deltaTrain,deltaDeltaTrain] = mfcc(TrainwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            [coeffsTest,deltaTest,deltaDeltaTest] = mfcc(TestwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            
            TrainFeatures = [coeffsTrain,deltaTrain,deltaDeltaTrain];
            TestFeatures = [coeffsTest,deltaTest,deltaDeltaTest];
            
            % normalize the data
            TrainNormFeatures = ((TrainFeatures-mu))./sigma;
            TestNormFeatures = ((TestFeatures-mu))./sigma;

            [coeffs,scoreTrain,~,~,~,mu] = pca(TrainFeatures,'NumComponents',2);
            
            TwitterGM =fitgmdist(scoreTrain,64,'CovarianceType','diagonal','SharedCovariance',false,'Replicates',5,'Options',statset('Display','iter','MaxIter',1200));

            TwitterPDF = @(x1,x2)reshape(pdf(TwitterGM,[x1(:) x2(:)]),size(x1));
            figure()
            N = 12.0;
            x=linspace(-N, N);
            y=x;
            [X,Y]=meshgrid(x,y);
            twitter = TwitterPDF(X,Y);
            h1=surf(X,Y,z,'FaceAlpha','0.5');
            set(h1,'facecolor','r')
            axis tight
%             title(['Trill GMM with 64 components  (MFCCs)']);
            rotate3d on;
            shading interp
            light
            view(3)
            hold on
            
            waveFile = CallNames{2};
            
            TrainwaveIn1 = audioread(['NEEDED/Training/' waveFile 'Train.wav']);
            TrainwaveIn2 = audioread(['NEEDED/Training/' waveFile 'Train2.wav']);
            TrainwaveIn = [TrainwaveIn1;TrainwaveIn2];
            
            TestwaveIn1 = audioread(['NEEDED/Testing/' waveFile 'Test.wav']);
            TestwaveIn2 = audioread(['NEEDED/Testing/' waveFile 'Test2.wav']);
            TestwaveIn = [TestwaveIn1;TestwaveIn2];
            
            [coeffsTrain,deltaTrain,deltaDeltaTrain] = mfcc(TrainwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            [coeffsTest,deltaTest,deltaDeltaTest] = mfcc(TestwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            
            TrainFeatures = [coeffsTrain,deltaTrain,deltaDeltaTrain];
            TestFeatures = [coeffsTest,deltaTest,deltaDeltaTest];
            
            % normalize the data
            TrainNormFeatures = ((TrainFeatures-mu))./sigma;
            TestNormFeatures = ((TestFeatures-mu))./sigma;

            [coeffs,scoreTrain,~,~,~,mu] = pca(TrainFeatures,'NumComponents',2);
            
            PheeGM =fitgmdist(scoreTrain,64,'CovarianceType','diagonal','SharedCovariance',false,'Replicates',5,'Options',statset('Display','iter','MaxIter',1200));

            PheePDF = @(x1,x2)reshape(pdf(PheeGM,[x1(:) x2(:)]),size(x1));
%             figure()
            N = 12.0;
            x=linspace(-N, N);
            y=x;
            [X,Y]=meshgrid(x,y);
            Phee = PheePDF(X,Y);
            h2=surf(X,Y,z,'FaceAlpha','0.5');
            set(h2,'facecolor','k')

            axis tight
%             title(['Trill GMM with 64 components  (MFCCs)']);
            rotate3d on;
            shading interp
            light
            view(3)
            hold on
            
            waveFile = CallNames{3};
            
            TrainwaveIn1 = audioread(['NEEDED/Training/' waveFile 'Train.wav']);
            TrainwaveIn2 = audioread(['NEEDED/Training/' waveFile 'Train2.wav']);
            TrainwaveIn = [TrainwaveIn1;TrainwaveIn2];
            
            TestwaveIn1 = audioread(['NEEDED/Testing/' waveFile 'Test.wav']);
            TestwaveIn2 = audioread(['NEEDED/Testing/' waveFile 'Test2.wav']);
            TestwaveIn = [TestwaveIn1;TestwaveIn2];
            
            [coeffsTrain,deltaTrain,deltaDeltaTrain] = mfcc(TrainwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            [coeffsTest,deltaTest,deltaDeltaTest] = mfcc(TestwaveIn,fs,'WindowLength',wlist(j),'OverlapLength',l(j),'NumCoeffs',numCoeffsList(k));
            
            TrainFeatures = [coeffsTrain,deltaTrain,deltaDeltaTrain];
            TestFeatures = [coeffsTest,deltaTest,deltaDeltaTest];
            
            % normalize the data
            TrainNormFeatures = ((TrainFeatures-mu))./sigma;
            TestNormFeatures = ((TestFeatures-mu))./sigma;

            [coeffs,scoreTrain,~,~,~,mu] = pca(TrainFeatures,'NumComponents',2);
            
            TrillGM =fitgmdist(scoreTrain,64,'CovarianceType','diagonal','SharedCovariance',false,'Replicates',5,'Options',statset('Display','iter','MaxIter',1200));

            TrillPDF = @(x1,x2)reshape(pdf(TrillGM,[x1(:) x2(:)]),size(x1));
%             figure()
            N = 12.0;
            x=linspace(-N, N);
            y=x;
            [X,Y]=meshgrid(x,y);
            Trill = TrillPDF(X,Y);
            h3=surf(X,Y,z,'FaceAlpha','0.5');
            set(h3,'facecolor','m')
            axis tight
%             title(['Trill GMM with 64 components  (MFCCs)']);
            rotate3d on;
            shading interp
            light
            view(3)
            hold off
        end
    end
end
