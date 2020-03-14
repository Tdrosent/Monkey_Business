function OMLSATrainingData()
fs = 96000;

dataPath = '../../../Data/SeperatedData/Training';
addpath(dataPath)

DataDir = char(dataPath);
wavFiles = char('/*.wav');

% make directories if they don't exist
if ~exist(strcat(dataPath, '/OMLSATrainingDataFirstPass'))
   mkdir(strcat(dataPath, '/OMLSATrainingDataFirstPass'))
end
FirstPassPath = char(strcat(dataPath,'/OMLSATrainingDataFirstPass/'));

if ~exist(strcat(dataPath, '/OMLSATrainingDataSecondPass'))
   mkdir(strcat(dataPath, '/OMLSATrainingDataSecondPass'))
end

SecondPassPath = char(strcat(dataPath,'/OMLSATrainingDataSecondPass/'));

wavFileStruct = dir(strcat(DataDir,wavFiles));
TotalCallsDir = {wavFileStruct.name}';

for i = 1:length(TotalCallsDir)
    %First pass through omlsa
    omlsa(strcat(dataPath,'/',TotalCallsDir{i}(1:end-4)),...
        strcat(FirstPassPath,TotalCallsDir{i}(1:end-4),'-FirstPass'));
    %Second pass through omlsa
    omlsa(strcat(FirstPassPath,TotalCallsDir{i}(1:end-4),'-FirstPass'),...
        strcat(SecondPassPath,TotalCallsDir{i}(1:end-4),'-SecondPass'));
end