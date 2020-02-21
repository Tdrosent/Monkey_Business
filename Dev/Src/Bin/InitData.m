%This file is just loading in the data
%Top level will be calls
%Class will be next level
function MonkeyCalls=InitData()
global Fs
w = 0.025*Fs;
l = floor(.4*w);
numCoeffs = 12;

%Check Pre-Emph filt and Lifter

Fs = 96000;
hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',Fs);
TrainingDataDir = char('./TrainingData'); 
addpath(TrainingDataDir);


fileTypes = char('/*.wav');

FolderStruct = dir(strcat(TrainingDataDir,fileTypes));

TotalCallsDir = {FolderStruct.name}';


PossibleCalls = {'combo', 'peep', 'peep_string', 'phee',  ... 
                  'trill' ,'tsik' ,'tsik_string', 'twitter','unvoiced'};
              
for i =1:length(PossibleCalls)
   Calls.(PossibleCalls{i})={}; 
end
sanitycheck =0;
TotalCalls  = 0;
for i = 1:length(TotalCallsDir)
    TotalCalls = TotalCalls +1;
    CurrentFile = char(TotalCallsDir{i});
    lengthOfFile = length(CurrentFile);
    for j = 1:length(PossibleCalls)
        PossibleCall = char(PossibleCalls{j});
        if (lengthOfFile-(length(PossibleCall)+3)) <= 0
            continue
        end
        if strcmp(PossibleCall,CurrentFile(lengthOfFile-(length(PossibleCall)+3):lengthOfFile-4))
            %% Additional comments - Remove later [TR]
            %  I think we should average down to one channel, HPF to remove
            %  low noise, apply a pre-emph filter, then extract MFCC
            %  coeffs. 
            temp = audioread(strcat(TrainingDataDir,'/',CurrentFile));
            if length(temp) < 24
                sanitycheck= sanitycheck+1;
                break
            end
            try
            HPFData = filtfilt(hpFilt,temp);
            catch exception
                c=1;
            end
            AvergedHPFCall = 1/2*(HPFData(:,1)+HPFData(:,2));
            try
                [coeffs,delta,deltaDelta] = mfcc(AvergedHPFCall,Fs,'WindowLength',w,'OverlapLength',l,'NumCoeffs',numCoeffs);
            catch 
                c=1;
            end
            catFeatures = [coeffs,delta,deltaDelta];    
            monkeyCall(i,1) = {catFeatures};
            monkeyCall(i,2) = {PossibleCall};
            if i == 1
                tempData = catFeatures;
            else
                tempData = [tempData ; catFeatures];
            end
            break
        end
    end
end
%csvwrite('monkeyCallData.csv',tempData);
meanVector = mean(tempData);
stdVector = std(tempData);
monkeyCall = monkeyCall(~cellfun(@isempty, monkeyCall(:,1)), :);
for k = 1:length(monkeyCall)
    monkeyCall{k,1} = (monkeyCall{k,1}-meanVector)./stdVector;
end
NormalizationSturct.Mean = meanVector;
NormalizationSturct.std = stdVector;

save('NormalizationStruct.mat','NormalizationSturct');
monkeyCall = sortrows(monkeyCall,2);


strlist = monkeyCall(:,2);
ComboIndex = find(cellfun('length',regexp(strlist,'^combo$')) == 1);
PeepIndex = find(cellfun('length',regexp(strlist,'^peep$')) == 1);
Peep_StringIndex = find(cellfun('length',regexp(strlist,'^peep\_string$')) == 1);
PheeIndex = find(cellfun('length',regexp(strlist,'^phee$')) == 1);
TrillIndex = find(cellfun('length',regexp(strlist,'^trill$')) == 1);
TsikIndex = find(cellfun('length',regexp(strlist,'^tsik$'))==1);
Tsik_StringIndex = find(cellfun('length',regexp(strlist,'^tsik\_string$')) == 1);
TwitterIndex = find(cellfun('length',regexp(strlist,'^twitter$')) == 1);
nonVoiceIndex = find(cellfun('length',regexp(strlist,'^unvoiced$')) == 1);

debugCheck = length(ComboIndex) + length(PeepIndex) + length(Peep_StringIndex) ...
    + length(PheeIndex) + length(TrillIndex) + length(TsikIndex) + length(Tsik_StringIndex) ...
    + length(TwitterIndex)+length(nonVoiceIndex);
if debugCheck ~= TotalCalls-sanitycheck
    disp('ERROR Index list != Input List!')
end
%(?Peep\b

MonkeyCalls.ComboCalls.Data = monkeyCall(ComboIndex,1);
MonkeyCalls.PeepCalls.Data = monkeyCall(PeepIndex,1);
MonkeyCalls.Pepp_StringCalls.Data = monkeyCall(Peep_StringIndex,1);
MonkeyCalls.PheeCalls.Data = monkeyCall(PheeIndex,1);
MonkeyCalls.TrillCalls.Data = monkeyCall(TrillIndex,1);
MonkeyCalls.TsikCalls.Data = monkeyCall(TsikIndex,1);
MonkeyCalls.Tsik_StringCalls.Data = monkeyCall(Tsik_StringIndex,1);
MonkeyCalls.TwitterCalls.Data = monkeyCall(TwitterIndex,1);
MonkeyCalls.nonVoiceCalls.Data = monkeyCall(nonVoiceIndex,1);

FileNames = fieldnames(MonkeyCalls);

for i = 1 :length(FileNames)
    PlaceHolder = [];
    for k = 1:length(MonkeyCalls.(FileNames{i}).Data)
       PlaceHolder = [ PlaceHolder; MonkeyCalls.(FileNames{i}).Data{k}];
    end
    MonkeyCalls.GMMData.Calls.(FileNames{i}) = PlaceHolder;
    MonkeyCalls.(FileNames{i}).mean = mean(PlaceHolder);
    MonkeyCalls.(FileNames{i}).Cov = cov(PlaceHolder);
    MonkeyCalls.GMMData.Names(i) = {FileNames{i}};
    MonkeyCalls.GMMData.Means(i,:) = mean(PlaceHolder);
    MonkeyCalls.GMMData.Cov(:,:,i) = cov(PlaceHolder);
end
save('MonkeyData_New_11-9-19.mat', '-struct','MonkeyCalls');
c=1;
