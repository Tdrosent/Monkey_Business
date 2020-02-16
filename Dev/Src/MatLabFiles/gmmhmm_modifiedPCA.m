clear
clc
addpath(genpath('C:\GitHub\SHS598_Project\HMM'))
addpath('NEEDED/GMMFeatures')

Q = 7;      % this is the total number of states in the model. I have 2 states in this model. For you guys this is the number of calls
O = 63;     % This is the dimension of your observations. All of your GMMs will be of this dimension. For you guys, that's the MFCC dimension


% load in normalized mfcc features
combo = load('Features_20mfccs_comboCalls.mat');
combo = combo.normFeatures(:,:);
lengthCombo = length(combo);

peep = load('Features_20mfccs_peepCalls.mat');
peep = peep.normFeatures(:,:);

peepString = load('Features_20mfccs_peepStringCalls.mat');
peepString = peepString.normFeatures(:,:);
peep = [peep;peepString];
lengthPeep = length(peep);

tsik = load('Features_20mfccs_tsikCalls.mat');
tsik = tsik.normFeatures(:,:);

tsikString = load('Features_20mfccs_tsikStringCalls.mat');
tsikString = tsikString.normFeatures(:,:);
tsik = [tsik;tsikString];
lengthTsik = length(tsik);

noVoice = load('Features_20mfccs_noVoiceCalls.mat');
noVoice = noVoice.normFeatures(:,:);
lengthNoVoice = length(noVoice);

twitter = load('Features_20mfccs_twitterCalls.mat');
twitter = twitter.normFeatures(:,:);
lengthTwitter = length(twitter);

trill = load('Features_20mfccs_trillCalls.mat');
trill = trill.normFeatures(:,:);
lengthTrill = length(trill);

phee = load('Features_20mfccs_pheeCalls.mat');
phee = phee.normFeatures(:,:);
lengthPhee = length(phee);

fullFeature = [combo ;peep ;tsik; noVoice;twitter;trill;phee];
[coefs,score] = pca(fullFeature,'NumComponents',2);

Names = {};
ComboStartIndex =1;
for i = 1:lengthCombo
    Names(i) = {'Combo'};
end
k=length(Names);
ComboEndIndex = k;
PeepStartIndex =k+1;
for i = 1:lengthPeep
    Names(i+k) = {'Peep'};
end
k=length(Names);
PeepEndIndex = k;
TsikStartIndex =k+1;
for i = 1:lengthTsik
    Names(i+k) = {'Tsik'};
end
k=length(Names);
TsikEndIndex = k;
NoVoiceStartIndex =k+1;
for i = 1:lengthNoVoice
    Names(i+k)={'NoVoice'};
end
k=length(Names);
NoVoiceEndIndex = k;
TwitterStartIndex =k+1;
for i = 1:lengthTwitter
    Names(i+k)={'Twitter'};
end
k=length(Names);
TwitterEndIndex = k;
TrilStartIndex =k+1;
for i = 1:lengthTrill
    Names(i+k)={'Trill'};
end
k=length(Names);
TrillEndIndex = k;
PheeStartIndex =k+1;
for i = 1:lengthPhee
    Names(i+k)={'Phee'};
end
k=length(Names);
PheeEndIndex = k;
Names = Names';
figure()
gscatter(score(:,1),score(:,2),Names);
title('Z-scored');

figure()
h = biplot(coefs(:,1:2),'Scores',score(:,1:2));
rotate3d on;
title('Showing Axis');

figure()
subplot(4,2,1)
scatter(score(ComboStartIndex:ComboEndIndex,1),score(ComboStartIndex:ComboEndIndex,2))
title('Combo Z-Score');

subplot(4,2,2)
scatter(score(PeepStartIndex:PeepEndIndex,1),score(PeepStartIndex:PeepEndIndex,2))
title('Peep Z-Score');

subplot(4,2,3)
scatter(score(TsikStartIndex:TsikEndIndex,1),score(TsikStartIndex:TsikEndIndex,2))
title('Tsik Z-Score');

subplot(4,2,4)
scatter(score(NoVoiceStartIndex:NoVoiceEndIndex,1),score(NoVoiceStartIndex:NoVoiceEndIndex,2))
title('NoVoice Z-Score');

subplot(4,2,5)
scatter(score(TwitterStartIndex:TwitterEndIndex,1),score(TwitterStartIndex:TwitterEndIndex,2))
title('Twitter Z-score');

subplot(4,2,6)
scatter(score(TrilStartIndex:TrillEndIndex,1),score(TrilStartIndex:TrillEndIndex,2))
title('Trill Z-Score');
subplot(4,2,7)
scatter(score(PheeStartIndex:PheeEndIndex,1),score(PheeStartIndex:PheeEndIndex,2))
title('Phee Z-Score');

% load in normalized mfcc features
combo = load('Features_20mfccs_comboCalls_NonZScore.mat');
combo = combo.Features(:,:);
lengthCombo = length(combo);

peep = load('Features_20mfccs_peepCalls_NonZScore.mat');
peep = peep.Features(:,:);

peepString = load('Features_20mfccs_peepStringCalls_NonZScore.mat');
peepString = peepString.Features(:,:);
peep = [peep;peepString];
lengthPeep = length(peep);

tsik = load('Features_20mfccs_tsikCalls_NonZScore.mat');
tsik = tsik.Features(:,:);

tsikString = load('Features_20mfccs_tsikStringCalls_NonZScore.mat');
tsikString = tsikString.Features(:,:);
tsik = [tsik;tsikString];
lengthTsik = length(tsik);

noVoice = load('Features_20mfccs_noVoiceCalls_NonZScore.mat');
noVoice = noVoice.Features(:,:);
lengthNoVoice = length(noVoice);

twitter = load('Features_20mfccs_twitterCalls_NonZScore.mat');
twitter = twitter.Features(:,:);
lengthTwitter = length(twitter);

trill = load('Features_20mfccs_trillCalls_NonZScore.mat');
trill = trill.Features(:,:);
lengthTrill = length(trill);

phee = load('Features_20mfccs_pheeCalls_NonZScore.mat');
phee = phee.Features(:,:);
lengthPhee = length(phee);

fullFeature = [combo ;peep ;tsik; noVoice;twitter;trill;phee];
[~,score2] = pca(fullFeature,'NumComponents',2);
Names = {};
Names = {};
ComboStartIndex =1;
for i = 1:lengthCombo
    Names(i) = {'Combo'};
end
k=length(Names);
ComboEndIndex = k;
PeepStartIndex =k+1;
for i = 1:lengthPeep
    Names(i+k) = {'Peep'};
end
k=length(Names);
PeepEndIndex = k;
TsikStartIndex =k+1;
for i = 1:lengthTsik
    Names(i+k) = {'Tsik'};
end
k=length(Names);
TsikEndIndex = k;
NoVoiceStartIndex =k+1;
for i = 1:lengthNoVoice
    Names(i+k)={'NoVoice'};
end
k=length(Names);
NoVoiceEndIndex = k;
TwitterStartIndex =k+1;
for i = 1:lengthTwitter
    Names(i+k)={'Twitter'};
end
k=length(Names);
TwitterEndIndex = k;
TrilStartIndex =k+1;
for i = 1:lengthTrill
    Names(i+k)={'Trill'};
end
k=length(Names);
TrillEndIndex = k;
PheeStartIndex =k+1;
for i = 1:lengthPhee
    Names(i+k)={'Phee'};
end
k=length(Names);
PheeEndIndex = k;
Names = Names';

figure()
subplot(4,2,1)
scatter(score2(ComboStartIndex:ComboEndIndex,1),score2(ComboStartIndex:ComboEndIndex,2))
title('Combo Regular');

subplot(4,2,2)
scatter(score2(PeepStartIndex:PeepEndIndex,1),score2(PeepStartIndex:PeepEndIndex,2))
title('Peep Regular');

subplot(4,2,3)
scatter(score2(TsikStartIndex:TsikEndIndex,1),score2(TsikStartIndex:TsikEndIndex,2))
title('Tsik Regular');

subplot(4,2,4)
scatter(score2(NoVoiceStartIndex:NoVoiceEndIndex,1),score2(NoVoiceStartIndex:NoVoiceEndIndex,2))
title('NoVoice Regular');

subplot(4,2,5)
scatter(score2(TwitterStartIndex:TwitterEndIndex,1),score2(TwitterStartIndex:TwitterEndIndex,2))
title('Twitter Regular');

subplot(4,2,6)
scatter(score2(TrilStartIndex:TrillEndIndex,1),score2(TrilStartIndex:TrillEndIndex,2))
title('Trill Regular');
subplot(4,2,7)
scatter(score2(PheeStartIndex:PheeEndIndex,1),score2(PheeStartIndex:PheeEndIndex,2))
title('Phee Regular');

figure()
gscatter(score2(:,1),score2(:,2),Names);
title('Regular Data');

c=1;

% seqSize = 5000;     % You are observing the sequence for this many time points
% numSeq = floor(length/seqSize);   % You are observing a total of this many sequences. This is the total number of training sequences


% I generate 50 instances of a sequence where the first 10 samples are
% state 1, the next 2 are state 2, the next 5 are state 1 and the final 15
% are state 2. The distribution of the two states is P(X | q=1) = Normal(0,1)
% and P(X| q = 2) = Normal(15, 1). For you guys, this will be the labeled
% monkeyd data
% for i= 1:numSeq
%     data(:,:,i) = featureSet.Features(startSeq:endSeq,:)';
%     startSeq = startSeq + seqSize;
%     endSeq   = endSeq + seqSize;
%     seqIdx = seqIdx + 1;
% end


% Initialize the GMM. 
M = 8;      % this is the number of gaussians in each mixture

% random initialization of the prior probabilities and of the state
% transition matrix. These will be further refined using the Baum-Welch
% algorithm below
prior0 = normalise(rand(Q,1));    % initial prior probability vector for the two states.
transmat0 = mk_stochastic(rand(Q,Q));    % initial transition probability matrix

% I am setting the initial means and variances for each GMM for each state
% using a not so good approach. Basically I fit it to data from each state


% state-wise features

% state order:

%1-nonVoice
%2-peep
%3-phee
%4-trill
%5-tsik
%6-twitter
%7-combo


% get data for state 1 and fit a GMM
[mu0_1, Sigma0_1, weights_1] = mixgauss_init(M, noVoice', 'diag');

% get data for state 2 and fit a GMM
[mu0_2, Sigma0_2, weights_2] = mixgauss_init(M, peep', 'diag');

% get data for state 3 and fit a GMM
[mu0_3, Sigma0_3, weights_3] = mixgauss_init(M, phee', 'diag');

% get data for state 4 and fit a GMM
[mu0_4, Sigma0_4, weights_4] = mixgauss_init(M, trill', 'diag');

% get data for state 5 and fit a GMM
[mu0_5, Sigma0_5, weights_5] = mixgauss_init(M, tsik', 'diag');

% get data for state 6 and fit a GMM
[mu0_6, Sigma0_6, weights_6] = mixgauss_init(M, twitter', 'diag');

% get data for state 7 and fit a GMM
[mu0_7, Sigma0_7, weights_7] = mixgauss_init(M, combo', 'diag');



mu0(:,1,:) = mu0_1;
mu0(:,2,:) = mu0_2;
mu0(:,3,:) = mu0_3;
mu0(:,4,:) = mu0_4;
mu0(:,5,:) = mu0_5;
mu0(:,6,:) = mu0_6;
mu0(:,7,:) = mu0_7;


%This is the covariance matrix for each state's GMM
Sigma0(:,:,1,:) = Sigma0_1;
Sigma0(:,:,2,:) = Sigma0_2;
Sigma0(:,:,3,:) = Sigma0_3;
Sigma0(:,:,4,:) = Sigma0_4;
Sigma0(:,:,5,:) = Sigma0_5;
Sigma0(:,:,6,:) = Sigma0_6;
Sigma0(:,:,7,:) = Sigma0_7;


% This is the GMM mixing matrix for each state. It is of size number of states by number
% of GMMs
mixmat0(1,:) = weights_1';
mixmat0(2,:) = weights_2';
mixmat0(3,:) = weights_3';
mixmat0(4,:) = weights_4';
mixmat0(5,:) = weights_5';
mixmat0(6,:) = weights_6';
mixmat0(7,:) = weights_7';


GMMstats = {mu0,Sigma0,mixmat0};
save('NEEDED/GMM_k8_.075ms_20mfcc.mat','GMMstats')
% Use Baum-Welch to refine the GMM estimates within the GMM and to learn
% the priors and the transition matrix
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 10);

c=1;
%generate a new test sequence - this one has a different sequence from the training set (20 of
%class 2, 15 of class 1, and 15 of class 2
% data_test(:,:,1) = [randn(20,2)+2; randn(10,2); randn(5,2); randn(15, 2)+2]';  
% 
% % calculate path likelihood
% B = mixgauss_prob(data_test, mu1, Sigma1, mixmat1);
% 
% % calculate the optimal path
% [path] = viterbi_path(prior1, transmat1, B);

% now you can compare the optimal path to the actual path you generated
% in the test data to compute an error