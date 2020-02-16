addpath('Production')
% k = number of mixtures per call
% CovType = 'full' or 'diagonal'
% SharedCov = Boolean (true, false)
%function buildGMM(k,CovType, SharedCov)

buildGMM(4,'diagonal',true);
buildGMM(16,'diagonal',true);
buildGMM(24,'diagonal',true);
buildGMM(32,'diagonal',true);
buildGMM(48,'diagonal',true);
buildGMM(64,'diagonal',true);