function callSeparation()

% mkdir('NEEDED/Training')
% mkdir('NEEDED/Testing')

addpath('NEEDED')
addpath('Data')
[audio, fs] = audioread('STE-010.wav');
load('marker_010.mat');

peepTimes = [];
peepStringTimes = [];
tsikTimes = [];
tsikStringTimes = [];
pheeTimes = [];
twitterTimes = [];
comboTimes = [];
trillTimes = [];


hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',fs);
 



% find call sample range

for i = 1:length(all_markers_time)
    all_markers_time(i,1) = floor(fs*all_markers_time(i,1));
    all_markers_time(i,2) = ceil(fs*all_markers_time(i,2));
end
if all_markers_time(1,1) == 0
    all_markers_time(1,1) = 1;
end
if all_markers_time(end,2) > length(audio)
    all_markers_time(end,2) = length(audio);
end

for i = 1:length(all_markers_time)
    if strcmp('peep',all_markers(i))
        peepTimes = [peepTimes; all_markers_time(i,:)];
    elseif strcmp('peep_string',all_markers(i))
        peepStringTimes = [peepStringTimes; all_markers_time(i,:)];
    elseif strcmp('phee',all_markers(i))
        pheeTimes = [pheeTimes; all_markers_time(i,:)];
    elseif strcmp('tsik',all_markers(i))
        tsikTimes = [tsikTimes; all_markers_time(i,:)];
    elseif strcmp('tsik_string',all_markers(i))
        tsikStringTimes = [tsikStringTimes; all_markers_time(i,:)];
    elseif strcmp('twitter',all_markers(i))
        twitterTimes = [twitterTimes; all_markers_time(i,:)];
    elseif strcmp('combo',all_markers(i))
        comboTimes = [comboTimes; all_markers_time(i,:)];
    elseif strcmp('trill',all_markers(i))
        trillTimes = [trillTimes; all_markers_time(i,:)];
    end
end

% generate call compilations

% peep
peepCalls = [];
for i = 1:length(peepTimes)
    peepCalls = [peepCalls ;audio(peepTimes(i,1):peepTimes(i,2),:)];
end
HPFpeepCalls= filtfilt(hpFilt,peepCalls);
AvergedHPFpeepCalls = 1/2*(HPFpeepCalls(:,1)+HPFpeepCalls(:,2));
AveragedHPFpeepCallsTrain = AvergedHPFpeepCalls(1:floor(end*.8));
AveragedHPFpeepCallsTest = AvergedHPFpeepCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/peepCallsTrain.wav',AveragedHPFpeepCallsTrain,fs);
audiowrite('NEEDED/Testing/peepCallsTest.wav',AveragedHPFpeepCallsTest,fs);


% peep string
peepStringCalls = [];
for i = 1:length(peepStringTimes)
    peepStringCalls = [peepStringCalls ;audio(peepStringTimes(i,1):peepStringTimes(i,2),:)];
end
HPFpeepStringCalls= filtfilt(hpFilt,peepStringCalls);
AvergedHPFpeepStringCalls = 1/2*(HPFpeepStringCalls(:,1)+HPFpeepStringCalls(:,2));
AveragedHPFpeepStringCallsTrain = AvergedHPFpeepStringCalls(1:floor(end*.8));
AveragedHPFpeepStringCallsTest = AvergedHPFpeepStringCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/peepStringCallsTrain.wav',AveragedHPFpeepStringCallsTrain,fs);
audiowrite('NEEDED/Testing/peepStringCallsTest.wav',AveragedHPFpeepStringCallsTest,fs);

% twitter
twitterCalls = [];
for i = 1:length(twitterTimes)
    twitterCalls = [twitterCalls; audio(twitterTimes(i,1):twitterTimes(i,2),:)];
end
HPFtwitterCalls = filtfilt(hpFilt,twitterCalls);
AvergedHPFtwitterCalls = 1/2*(HPFtwitterCalls(:,1)+HPFtwitterCalls(:,2));
AveragedHPFtwitterCallsTrain = AvergedHPFtwitterCalls(1:floor(end*.8));
AveragedHPFtwitterCallsTest = AvergedHPFtwitterCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/twitterCallsTrain.wav',AveragedHPFtwitterCallsTrain,fs);
audiowrite('NEEDED/Testing/twitterCallsTest.wav',AveragedHPFtwitterCallsTest,fs);

% tsik
tsikCalls = [];
for i = 1:length(tsikTimes)
    tsikCalls = [tsikCalls ;audio(tsikTimes(i,1):tsikTimes(i,2),:)];
end
HPFtsikCalls = filtfilt(hpFilt,tsikCalls);
AvergedHPFtsikCalls = 1/2*(HPFtsikCalls(:,1)+HPFtsikCalls(:,2));
AveragedHPFtsikCallsTrain = AvergedHPFtsikCalls(1:floor(end*.8));
AveragedHPFtsikCallsTest = AvergedHPFtsikCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/tsikCallsTrain.wav',AveragedHPFtsikCallsTrain,fs);
audiowrite('NEEDED/Testing/tsikCallsTest.wav',AveragedHPFtsikCallsTest,fs);

% tsik string
tsikStringCalls = [];
for i = 1:length(tsikStringTimes)
    tsikStringCalls = [tsikStringCalls; audio(tsikStringTimes(i,1):tsikStringTimes(i,2),:)];
end
HPFtsikStringCalls = filtfilt(hpFilt,tsikStringCalls);
AvergedHPFtsikStringCalls = 1/2*(HPFtsikStringCalls(:,1)+HPFtsikStringCalls(:,2));
AveragedHPFtsikCallsTrain = AvergedHPFtsikStringCalls(1:floor(end*.8));
AveragedHPFtsikCallsTest = AvergedHPFtsikStringCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/tsikStringCallsTrain.wav',AveragedHPFtsikCallsTrain,fs);
audiowrite('NEEDED/Testing/tsikStringCallsTest.wav',AveragedHPFtsikCallsTest,fs);

% phee
pheeCalls = [];
for i = 1:length(pheeTimes)
    pheeCalls = [pheeCalls ;audio(pheeTimes(i,1):pheeTimes(i,2),:)];
end
HPFpheeCalls = filtfilt(hpFilt,pheeCalls);
AvergedHPFpheeCalls = 1/2*(HPFpheeCalls(:,1)+HPFpheeCalls(:,2));
AveragedHPFpheeCallsTrain = AvergedHPFpheeCalls(1:floor(end*.8));
AveragedHPFpheeCallsTest = AvergedHPFpheeCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/pheeCallsTrain.wav',AveragedHPFpheeCallsTrain,fs);
audiowrite('NEEDED/Testing/pheeCallsTest.wav',AveragedHPFpheeCallsTest,fs);

% combo
comboCalls = [];
for i = 1:length(comboTimes)
    comboCalls = [comboCalls ;audio(comboTimes(i,1):comboTimes(i,2),:)];
end
HPFcomboCalls = filtfilt(hpFilt,comboCalls);
AvergedHPFcomboCalls = 1/2*(HPFcomboCalls(:,1)+HPFcomboCalls(:,2));
AveragedHPFcomboCallsTrain = AvergedHPFcomboCalls(1:floor(end*.8));
AveragedHPFcomboCallsTest = AvergedHPFcomboCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/comboCallsTrain.wav',AveragedHPFcomboCallsTrain,fs);
audiowrite('NEEDED/Testing/comboCallsTest.wav',AveragedHPFcomboCallsTest,fs);

% trill
trillCalls = [];
for i = 1:length(trillTimes)
    trillCalls = [trillCalls ;audio(trillTimes(i,1):trillTimes(i,2),:)];
end
HPFtrillCalls = filtfilt(hpFilt,trillCalls);
AvergedHPFtrillCalls = 1/2*(HPFtrillCalls(:,1)+HPFtrillCalls(:,2));
AveragedHPFtrillCallsTrain = AvergedHPFtrillCalls(1:floor(end*.8));
AveragedHPFtrillCallsTest = AvergedHPFtrillCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/trillCallsTrain.wav',AveragedHPFtrillCallsTrain,fs);
audiowrite('NEEDED/Testing/trillCallsTest.wav',AveragedHPFtrillCallsTest,fs);

% create noVoice audio
noVoiceCalls = audio;
for i = 1:length(all_markers_time)
    noVoiceCalls(all_markers_time(i,1):all_markers_time(i,2),:) = 0;
end
voiceIndex = find(noVoiceCalls(:,1) == 0);
noVoiceCalls(voiceIndex,:) = [];
HPFnoVoiceCalls= filtfilt(hpFilt,noVoiceCalls);
AvergedHPFnoVoiceCalls = 1/2*(HPFnoVoiceCalls(:,1)+HPFnoVoiceCalls(:,2));
AveragedHPFnoVoiceCallsTrain = AvergedHPFnoVoiceCalls(1:floor(end*.8));
AveragedHPFnoVoiceCallsTest = AvergedHPFnoVoiceCalls(ceil(end*.8):end);
audiowrite('NEEDED/Training/noVoiceCallsTrain.wav',AveragedHPFnoVoiceCallsTrain,fs);
audiowrite('NEEDED/Testing/noVoiceCallsTest.wav',AveragedHPFnoVoiceCallsTest,fs);
