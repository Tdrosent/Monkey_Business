% k = number of mixtures per call
% CovType = 'full' or 'diagonal'
% SharedCov = Boolean (true, false)
function buildGMM(k,CovType, SharedCov)
addpath('./Models');

Struct = open('GMMData_11-9-19.mat');
GmmData = Struct.GmmStuct;
CallNames = fieldnames(GmmData.Calls);
GMMModel = cell(length(CallNames),1);
for i = 1:length(CallNames)
    GMMModel{i} = fitgmdist(GmmData.Calls.(CallNames{i}),k,'CovarianceType',CovType,'SharedCov',SharedCov,'Replicates',2);
end
if SharedCov == 1
    output = 'True';
else
    output = 'False';
end
save(strcat('Models/GMMModel', num2str(k),'SharedCov', output,'.mat'), 'GMMModel');