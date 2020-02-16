clear
% clc
addpath(genpath('C:\GitHub\SHS598_Project\HMM'))
addpath('NEEDED/GMMFeatures')

% load in normalized mfcc features
fullData = load('Features_12mfccs_20ms_FULL_allData.mat');
fullData = fullData.normFeatures(:,:);

Q = 7;      % this is the total number of states in the model. I have 2 states in this model. For you guys this is the number of calls
O = 63;     % This is the dimension of your observations. All of your GMMs will be of this dimension. For you guys, that's the MFCC dimension
T = 25;     % You are observing the sequence for this many time points
nex = floor(length(fullData)/T);   % You are observing a total of this many sequences. This is the total number of training sequences
disp(['T = ' num2str(T)])
startSeq = 1;
endSeq = T;

% generate sequences
for i = 1:nex
   data(:,:,i) =  fullData(startSeq:endSeq,:)';
   startSeq = startSeq+T;
   endSeq = endSeq+T;
end

% load in normalized mfcc features

combo = load('Features_12mfccs_20ms_FULL_comboCalls.mat');
combo = combo.normFeatures(:,:);

peep = load('Features_12mfccs_20ms_FULL_peepCalls.mat');
peep = peep.normFeatures(:,:);

peepString = load('Features_12mfccs_20ms_FULL_peepStringCalls.mat');
peepString = peepString.normFeatures(:,:);
peep = [peep;peepString];

tsik = load('Features_12mfccs_20ms_FULL_tsikCalls.mat');
tsik = tsik.normFeatures(:,:);

tsikString = load('Features_12mfccs_20ms_FULL_tsikStringCalls.mat');
tsikString = tsikString.normFeatures(:,:);
tsik = [tsik;tsikString];

noVoice = load('Features_12mfccs_20ms_FULL_noVoiceCalls.mat');
noVoice = noVoice.normFeatures(:,:);

twitter = load('Features_12mfccs_20ms_FULL_twitterCalls.mat');
twitter = twitter.normFeatures(:,:);

trill = load('Features_12mfccs_20ms_FULL_trillCalls.mat');
trill = trill.normFeatures(:,:);

phee = load('Features_12mfccs_20ms_FULL_pheeCalls.mat');
phee = phee.normFeatures(:,:);

% voice = [combo ;phee ;peep ;trill ;twitter ;tsik];
% Initialize the GMM. 
M = 8;      % this is the number of gaussians in each mixture

% random initialization of the prior probabilities and of the state
% transition matrix. These will be further refined using the Baum-Welch
% algorithm below
prior0 = normalise(rand(Q,1));    % initial prior probability vector for the two states.
transmat0 = mk_stochastic(rand(Q,Q));    % initial transition probability matrix

% I am setting the initial means and variances for each GMM for each state
% using a not so good approach. Basically I fit it to data from each state


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


% get data for state 7 and fit a GMM
% [mu0_8, Sigma0_8, weights_8] = mixgauss_init(M, voice', 'diag');

% 
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

% GMMstats = {mu0,Sigma0,mixmat0};
% save('NEEDED/GMM_k8_.075ms_20mfcc.mat','GMMstats')

% Use Baum-Welch to refine the GMM estimates within the GMM and to learn
% the priors and the transition matrix
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 15);
GMMstatsEM = {mu1,Sigma1,mixmat1};
save('NEEDED/GMMEM_k8_.025ms_20mfcc.mat','GMMstatsEM')




% calculate path likelihood
B = mixgauss_prob([data(:,:,1),data(:,:,2),data(:,:,3)], mu1, Sigma1, mixmat1);

% calculate the optimal path
[path] = viterbi_path(prior1, transmat1, B);

% now you can compare the optimal path to the actual path you generated
% in the test data to compute an error