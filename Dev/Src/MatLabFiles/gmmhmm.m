clear
clc
addpath(genpath('C:\GitHub\SHS598_Project\HMMToolbox\HMMall'))

Q = 2;      % this is the total number of states in the model. I have 2 states in this model. For you guys this is the number of calls
O = 2;     % This is the dimension of your observations. All of your GMMs will be of this dimension. For you guys, that's the MFCC dimension
T = 50;     % You are observing the sequence for this many time points
nex = 20;   % You are observing a total of this many sequences. This is the total number of training sequences

% I generate 50 instances of a sequence where the first 10 samples are
% state 1, the next 2 are state 2, the next 5 are state 1 and the final 15
% are state 2. The distribution of the two states is P(X | q=1) = Normal(0,1)
% and P(X| q = 2) = Normal(15, 1). For you guys, this will be the labeled
% monkeyd data
for i= 1:nex
    data(:,:,i) = [randn(10,2); randn(20,2) + 2; randn(5,2); randn(15, 2)+2]';  
end


% Initialize the GMM. 
M = 3;      % this is the number of gaussians in each mixture

% random initialization of the prior probabilities and of the state
% transition matrix. These will be further refined using the Baum-Welch
% algorithm below
prior0 = normalise(rand(Q,1));    % initial prior probability vector for the two states.
transmat0 = mk_stochastic(rand(Q,Q));    % initial transition probability matrix

% I am setting the initial means and variances for each GMM for each state
% using a not so good approach. Basically I fit it to data from each state

% get data for state 1 and fit a GMM
[mu0_1, Sigma0_1 weights_1] = mixgauss_init(M, reshape(data(:,[1:10],:), [O 10*nex]), 'diag');

% get data for state 2 and fit a GMM
[mu0_2, Sigma0_2 weights_2] = mixgauss_init(M, reshape(data(:,[11:30],:), [O 20*nex]), 'diag');


mu0(:,1,:) = mu0_1;
mu0(:,2,:) = mu0_2;

%This is the covariance matrix for each state's GMM
Sigma0(:,:,1,:) = Sigma0_1;
Sigma0(:,:,2,:) = Sigma0_2;

% This is the GMM mixing matrix for each state. It is of size number of states by number
% of GMMs
mixmat0(1,:) = weights_1';
mixmat0(2,:) = weights_2';


% Use Baum-Welch to refine the GMM estimates within the GMM and to learn
% the priors and the transition matrix
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 10);


%generate a new test sequence - this one has a different sequence from the training set (20 of
%class 2, 15 of class 1, and 15 of class 2
data_test(:,:,1) = [randn(20,2)+2; randn(10,2); randn(5,2); randn(15, 2)+2]';  

% calculate path likelihood
B = mixgauss_prob(data_test, mu1, Sigma1, mixmat1);

% calculate the optimal path
[path] = viterbi_path(prior1, transmat1, B);

% now you can compare the optimal path to the actual path you generated
% in the test data to compute an error