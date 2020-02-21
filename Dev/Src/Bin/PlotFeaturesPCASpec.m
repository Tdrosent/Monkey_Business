clear
clc
addpath('NEEDED/')
addpath('NEEDED\ModelsTrainSpec\MODEL2\MODEL11\Normalized\Analyze');
Bigpath = dir('NEEDED/ModelsTrainSpec/MODEL2/MODEL11');

for z = 3:length(Bigpath)
    subClass = dir('C:\Git\Fall_2019\SHS598_Project\NEEDED\ModelsTrainSpec\MODEL2\MODEL11\Normalized\Analyze');
    NormalizedFolder = subClass;
%     RegularFolder = dir(strcat(subClass(1).folder,'\Regular\','*.mat'));
    
%     for l = 1:length({NormalizedFolder.folder})
%         NormalizedCallsName(l) = {strcat(NormalizedFolder(l).folder,'\',NormalizedFolder(l).name)};
% %         RegularCallsName(l)  = {strcat(RegularFolder(l).folder,'\',RegularFolder(l).name)};
%     end
    

% load in normalized mfcc features
% comboNorm = load(NormalizedCallsName{1});
% comboNorm = comboNorm.normFeatures(:,:);
% lengthComboNorm = length(comboNorm);


% noVoiceNorm = load(NormalizedCallsName{2});
% noVoiceNorm = noVoiceNorm.normFeatures(:,:);
% lengthNoVoiceNorm = length(noVoiceNorm);

% peepNorm = load(NormalizedCallsName{3});
% peepNorm = peepNorm.normFeatures(:,:);

% peepStringNorm = load(NormalizedCallsName{4});
% peepStringNorm = peepStringNorm.normFeatures(:,:);
% peepNorm = [peepNorm;peepStringNorm];
% lengthPeepNorm = length(peepNorm);

pheeNorm = load('Spectrum_Features_20ms_pheeCalls');
pheeNorm = pheeNorm.TrainNormFeatures(:,:);
lengthPheeNorm = length(pheeNorm);

trillNorm = load('Spectrum_Features_20ms_trillCalls');
trillNorm = trillNorm.TrainNormFeatures(:,:);
lengthTrillNorm = length(trillNorm);

% tsikNorm = load(NormalizedCallsName{7});
% tsikNorm = tsikNorm.normFeatures(:,:);

% tsikStringNorm = load(NormalizedCallsName{8});
% tsikStringNorm = tsikStringNorm.normFeatures(:,:);
% tsikNorm = [tsikNorm;tsikStringNorm];
% lengthTsikNorm = length(tsikNorm);


twitterNorm = load('Spectrum_Features_20ms_twitterCalls');
twitterNorm = twitterNorm.TrainNormFeatures(:,:);
lengthTwitterNorm = length(twitterNorm);


% comboRegular = load(RegularCallsName{1});
% comboRegular = comboRegular.Features(:,:);
% lengthComboRegular = length(comboRegular);
% 
% 
% noVoiceRegular = load(RegularCallsName{2});
% noVoiceRegular = noVoiceRegular.Features(:,:);
% lengthNoVoiceRegular = length(noVoiceRegular);
% 
% peepRegular = load(RegularCallsName{3});
% peepRegular = peepRegular.Features(:,:);
% 
% peepStringRegular = load(RegularCallsName{4});
% peepStringRegular = peepStringRegular.Features(:,:);
% peepRegular = [peepRegular;peepStringRegular];
% lengthPeepRegular = length(peepRegular);
% 
% pheeRegular = load(RegularCallsName{5});
% pheeRegular = pheeRegular.Features(:,:);
% lengthPheeRegular = length(pheeRegular);
% 
% trillRegular = load(RegularCallsName{6});
% trillRegular = trillRegular.Features(:,:);
% lengthTrillRegular = length(trillRegular);
% 
% tsikRegular = load(RegularCallsName{7});
% tsikRegular = tsikRegular.Features(:,:);
% 
% tsikStringRegular = load(RegularCallsName{8});
% tsikStringRegular = tsikStringRegular.Features(:,:);
% tsikRegular = [tsikRegular;tsikStringRegular];
% lengthTsikRegular = length(tsikRegular);
% 
% 
% twitterRegular = load(RegularCallsName{9});
% twitterRegular = twitterRegular.Features(:,:);
% lengthTwitterRegular = length(twitterRegular);
% comboNorm ;peepNorm ;tsikNorm; noVoiceNorm;
fullFeatureNorm = [twitterNorm;trillNorm;pheeNorm];
% fullFeatureRegular = [comboRegular ;peepRegular ;tsikRegular; noVoiceRegular;twitterRegular;trillRegular;pheeRegular];
[coefsNorm,scoreNorm] = pca(fullFeatureNorm,'NumComponents',2);
% [coefsRegular,scoreRegular] = pca(fullFeatureRegular,'NumComponents',2);

Names = {};
% ComboStartIndex =1;
% for i = 1:lengthComboNorm
%     Names(i) = {'Combo'};
% end
% k = length(Names);
% ComboEndIndex = k;
% NoVoiceStartIndex =k+1;
% for i = 1:lengthNoVoiceNorm
%     Names(i+k)={'NoVoice'};
% end
% k=length(Names);
% NoVoiceEndIndex = k;
% PeepStartIndex =k+1;
% for i = 1:lengthPeepNorm
%     Names(i+k) = {'Peep'};
% end
% k=length(Names);
% PeepEndIndex = k;
PheeStartIndex =1;
for i = 1:lengthPheeNorm
    Names(i)={'Phee'};
end
k=length(Names);
PheeEndIndex = k;
TrilStartIndex =k+1;
for i = 1:lengthTrillNorm
    Names(i+k)={'Trill'};
end
k=length(Names);
TrillEndIndex = k;
% TsikStartIndex =k+1;
% for i = 1:lengthTsikNorm
%     Names(i+k) = {'Tsik'};
% end
% k=length(Names);
% TsikEndIndex = k;
TwitterStartIndex =k+1;
for i = 1:lengthTwitterNorm
    Names(i+k)={'Twitter'};
end
k=length(Names);
TwitterEndIndex = k;


Names = Names';
fig1=figure('visible','on');
gscatter(scoreNorm(:,1),scoreNorm(:,2),Names);
title(strcat(Bigpath(z).name,' Z-scored '));
saveas(fig1,strcat(['./FeatureEvaluation/',Bigpath(z).name,'_Z-Scored-GScatter']),'jpg')

% fig2=figure('visible','off');
% gscatter(scoreRegular(:,1),scoreRegular(:,2),Names);
% title(strcat(Bigpath(z).name,' Regular Data '));
% saveas(fig2,strcat(['./FeatureEvaluation/',Bigpath(z).name,'_Regular-GScatter']),'jpg')

%% ZScore
fig3=figure('visible','off');
subplot(4,2,1)
scatter(scoreNorm(ComboStartIndex:ComboEndIndex,1),scoreNorm(ComboStartIndex:ComboEndIndex,2))
title(strcat(Bigpath(z).name,' Combo Z-Score'));

subplot(4,2,2)
scatter(scoreNorm(PeepStartIndex:PeepEndIndex,1),scoreNorm(PeepStartIndex:PeepEndIndex,2))
title(strcat(Bigpath(z).name,' Peep Z-Score'));

subplot(4,2,3)
scatter(scoreNorm(TsikStartIndex:TsikEndIndex,1),scoreNorm(TsikStartIndex:TsikEndIndex,2))
title(strcat(Bigpath(z).name,' Tsik Z-Score'));

subplot(4,2,4)
scatter(scoreNorm(NoVoiceStartIndex:NoVoiceEndIndex,1),scoreNorm(NoVoiceStartIndex:NoVoiceEndIndex,2))
title(strcat(Bigpath(z).name,' NoVoice Z-Score'));


subplot(4,2,5)
scatter(scoreNorm(TwitterStartIndex:TwitterEndIndex,1),scoreNorm(TwitterStartIndex:TwitterEndIndex,2))
title(strcat(Bigpath(z).name,' Combo Twitter Z-score'));


subplot(4,2,6)
scatter(scoreNorm(TrilStartIndex:TrillEndIndex,1),scoreNorm(TrilStartIndex:TrillEndIndex,2))
title(strcat(Bigpath(z).name,' Trill Z-Score'));


subplot(4,2,7)
scatter(scoreNorm(PheeStartIndex:PheeEndIndex,1),scoreNorm(PheeStartIndex:PheeEndIndex,2))
title(strcat(Bigpath(z).name,' Phee Z-Score'));
saveas(fig3,strcat(['./FeatureEvaluation/',Bigpath(z).name,'_Zscored-IndivScatter']),'jpg')

%%Regular Data
% fig4=figure('visible','off');
% subplot(4,2,1)
% scatter(scoreRegular(ComboStartIndex:ComboEndIndex,1),scoreRegular(ComboStartIndex:ComboEndIndex,2))
% title(strcat(Bigpath(z).name,' Combo Regular'));
% 
% subplot(4,2,2)
% scatter(scoreRegular(PeepStartIndex:PeepEndIndex,1),scoreRegular(PeepStartIndex:PeepEndIndex,2))
% title(strcat(Bigpath(z).name,' Peep Regular'));
% 
% subplot(4,2,3)
% scatter(scoreRegular(TsikStartIndex:TsikEndIndex,1),scoreRegular(TsikStartIndex:TsikEndIndex,2))
% title(strcat(Bigpath(z).name,' Tsik Regular'));
% 
% subplot(4,2,4)
% scatter(scoreRegular(NoVoiceStartIndex:NoVoiceEndIndex,1),scoreRegular(NoVoiceStartIndex:NoVoiceEndIndex,2))
% title(strcat(Bigpath(z).name,' NoVoice Regular'));
% 
% 
% subplot(4,2,5)
% scatter(scoreRegular(TwitterStartIndex:TwitterEndIndex,1),scoreRegular(TwitterStartIndex:TwitterEndIndex,2))
% title(strcat(Bigpath(z).name,' Combo Twitter Regular'));
% 
% 
% subplot(4,2,6)
% scatter(scoreRegular(TrilStartIndex:TrillEndIndex,1),scoreRegular(TrilStartIndex:TrillEndIndex,2))
% title(strcat(Bigpath(z).name,' Trill Regular'));
% 
% 
% subplot(4,2,7)
% scatter(scoreRegular(PheeStartIndex:PheeEndIndex,1),scoreRegular(PheeStartIndex:PheeEndIndex,2))
% title(strcat(Bigpath(z).name,' Phee Regular'));
% saveas(fig4,strcat(['./FeatureEvaluation/',Bigpath(z).name,'_Regular-IndivScatter']),'jpg')

end

