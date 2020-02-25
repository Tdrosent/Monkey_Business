function callSeparation()
fs = 96000;
% mkdir('NEEDED/Training')
% mkdir('NEEDED/Testing')

basePath = '../../../Data';
dataPath = '../../../Data';
addpath(basePath)

DataDir = char(dataPath);
wavFiles = char('/*.wav');
matFiles = char('/marker_*.mat');

% make directories if they don't exist
if ~exist(strcat(dataPath, '/SeperatedData'))
   mkdir(strcat(dataPath, '/SeperatedData'))
end
if ~exist(strcat(dataPath, '/SeperatedData/Training'))
   mkdir(strcat(dataPath, '/SeperatedData/Training'))
end
if ~exist(strcat(dataPath, '/SeperatedData/Testing'))
   mkdir(strcat(dataPath, '/SeperatedData/Testing'))
end

wavFileStruct = dir(strcat(DataDir,wavFiles));
matFileStruct = dir(strcat(DataDir,matFiles));
TotalCallsDir = {wavFileStruct.name}';


hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',fs);

% find call sample range
for k = 1:length(wavFileStruct)
    try
        currentFile = wavFileStruct(k).name;
        fileNum = currentFile(5:end-4);
        [audio, fs] = audioread(strcat(dataPath,'/',currentFile));
        load(strcat('marker_',fileNum,'.mat'));
        
        peepTimes = [];
        peepStringTimes = [];
        tsikTimes = [];
        tsikStringTimes = [];
        pheeTimes = [];
        twitterTimes = [];
        comboTimes = [];
        trillTimes = [];
        
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
        
        % peep
        peepCalls = [];
        for i = 1:length(peepTimes)
            peepCalls = [peepCalls ;audio(peepTimes(i,1):peepTimes(i,2),:)];
        end
        if ~isempty(peepCalls)
            HPFpeepCalls= filtfilt(hpFilt,peepCalls);
            AvergedHPFpeepCalls = 1/2*(HPFpeepCalls(:,1)+HPFpeepCalls(:,2));
            AveragedHPFpeepCallsTrain = AvergedHPFpeepCalls(1:floor(end*.8));
            AveragedHPFpeepCallsTest = AvergedHPFpeepCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/peepCallsTrain',fileNum,'.wav'),AveragedHPFpeepCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/peepCallsTest',fileNum,'.wav'),AveragedHPFpeepCallsTest,fs);
        end
        
        % peep string
        peepStringCalls = [];
        for i = 1:length(peepStringTimes)
            peepStringCalls = [peepStringCalls ;audio(peepStringTimes(i,1):peepStringTimes(i,2),:)];
        end
        if ~isempty(peepStringCalls)
            HPFpeepStringCalls= filtfilt(hpFilt,peepStringCalls);
            AvergedHPFpeepStringCalls = 1/2*(HPFpeepStringCalls(:,1)+HPFpeepStringCalls(:,2));
            AveragedHPFpeepStringCallsTrain = AvergedHPFpeepStringCalls(1:floor(end*.8));
            AveragedHPFpeepStringCallsTest = AvergedHPFpeepStringCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/peepStringCallsTrain',fileNum,'.wav'),AveragedHPFpeepStringCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/peepStringCallsTest',fileNum,'.wav'),AveragedHPFpeepStringCallsTest,fs);
        end
        % twitter
        twitterCalls = [];
        for i = 1:length(twitterTimes)
            twitterCalls = [twitterCalls; audio(twitterTimes(i,1):twitterTimes(i,2),:)];
        end
        if ~isempty(twitterCalls)
            HPFtwitterCalls = filtfilt(hpFilt,twitterCalls);
            AvergedHPFtwitterCalls = 1/2*(HPFtwitterCalls(:,1)+HPFtwitterCalls(:,2));
            AveragedHPFtwitterCallsTrain = AvergedHPFtwitterCalls(1:floor(end*.8));
            AveragedHPFtwitterCallsTest = AvergedHPFtwitterCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/twitterCallsTrain',fileNum,'.wav'),AveragedHPFtwitterCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/twitterCallsTest',fileNum,'.wav'),AveragedHPFtwitterCallsTest,fs);
        end
        % tsik
        tsikCalls = [];
        for i = 1:length(tsikTimes)
            tsikCalls = [tsikCalls ;audio(tsikTimes(i,1):tsikTimes(i,2),:)];
        end
        if ~isempty(tsikCalls)
            HPFtsikCalls = filtfilt(hpFilt,tsikCalls);
            AvergedHPFtsikCalls = 1/2*(HPFtsikCalls(:,1)+HPFtsikCalls(:,2));
            AveragedHPFtsikCallsTrain = AvergedHPFtsikCalls(1:floor(end*.8));
            AveragedHPFtsikCallsTest = AvergedHPFtsikCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/tsikCallsTrain',fileNum,'.wav'),AveragedHPFtsikCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/tsikCallsTest',fileNum,'.wav'),AveragedHPFtsikCallsTest,fs);
        end
        
        % tsik string
        tsikStringCalls = [];
        for i = 1:length(tsikStringTimes)
            tsikStringCalls = [tsikStringCalls; audio(tsikStringTimes(i,1):tsikStringTimes(i,2),:)];
        end
        if ~isempty(tsikStringCalls)
            HPFtsikStringCalls = filtfilt(hpFilt,tsikStringCalls);
            AvergedHPFtsikStringCalls = 1/2*(HPFtsikStringCalls(:,1)+HPFtsikStringCalls(:,2));
            AveragedHPFtsikCallsTrain = AvergedHPFtsikStringCalls(1:floor(end*.8));
            AveragedHPFtsikCallsTest = AvergedHPFtsikStringCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/tsikStringCallsTrain',fileNum,'.wav'),AveragedHPFtsikCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/tsikStringCallsTest',fileNum,'.wav'),AveragedHPFtsikCallsTest,fs);
        end
        % phee
        pheeCalls = [];
        for i = 1:length(pheeTimes)
            pheeCalls = [pheeCalls ;audio(pheeTimes(i,1):pheeTimes(i,2),:)];
        end
        if ~isempty(pheeCalls)
            HPFpheeCalls = filtfilt(hpFilt,pheeCalls);
            AvergedHPFpheeCalls = 1/2*(HPFpheeCalls(:,1)+HPFpheeCalls(:,2));
            AveragedHPFpheeCallsTrain = AvergedHPFpheeCalls(1:floor(end*.8));
            AveragedHPFpheeCallsTest = AvergedHPFpheeCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/pheeCallsTrain',fileNum,'.wav'),AveragedHPFpheeCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/pheeCallsTest',fileNum,'.wav'),AveragedHPFpheeCallsTest,fs);
        end
        % combo
        comboCalls = [];
        for i = 1:length(comboTimes)
            comboCalls = [comboCalls ;audio(comboTimes(i,1):comboTimes(i,2),:)];
        end
        if ~isempty(comboCalls)
            HPFcomboCalls = filtfilt(hpFilt,comboCalls);
            AvergedHPFcomboCalls = 1/2*(HPFcomboCalls(:,1)+HPFcomboCalls(:,2));
            AveragedHPFcomboCallsTrain = AvergedHPFcomboCalls(1:floor(end*.8));
            AveragedHPFcomboCallsTest = AvergedHPFcomboCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/comboCallsTrain',fileNum,'.wav'),AveragedHPFcomboCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/comboCallsTest',fileNum,'.wav'),AveragedHPFcomboCallsTest,fs);
        end
        % trill
        trillCalls = [];
        for i = 1:length(trillTimes)
            trillCalls = [trillCalls ;audio(trillTimes(i,1):trillTimes(i,2),:)];
        end
        if ~isempty(trillCalls)
            HPFtrillCalls = filtfilt(hpFilt,trillCalls);
            AvergedHPFtrillCalls = 1/2*(HPFtrillCalls(:,1)+HPFtrillCalls(:,2));
            AveragedHPFtrillCallsTrain = AvergedHPFtrillCalls(1:floor(end*.8));
            AveragedHPFtrillCallsTest = AvergedHPFtrillCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/trillCallsTrain',fileNum,'.wav'),AveragedHPFtrillCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/trillCallsTest',fileNum,'.wav'),AveragedHPFtrillCallsTest,fs);
        end
        % create noVoice audio
        noVoiceCalls = audio;
        for i = 1:length(all_markers_time)
            noVoiceCalls(all_markers_time(i,1):all_markers_time(i,2),:) = 0;
        end
        if ~isempty(noVoiceCalls)
            voiceIndex = find(noVoiceCalls(:,1) == 0);
            noVoiceCalls(voiceIndex,:) = [];
            HPFnoVoiceCalls= filtfilt(hpFilt,noVoiceCalls);
            AvergedHPFnoVoiceCalls = 1/2*(HPFnoVoiceCalls(:,1)+HPFnoVoiceCalls(:,2));
            AveragedHPFnoVoiceCallsTrain = AvergedHPFnoVoiceCalls(1:floor(end*.8));
            AveragedHPFnoVoiceCallsTest = AvergedHPFnoVoiceCalls(ceil(end*.8):end);
            audiowrite(strcat(dataPath,'/SeperatedData/Training/noVoiceCallsTrain',fileNum,'.wav'),AveragedHPFnoVoiceCallsTrain,fs);
            audiowrite(strcat(dataPath,'/SeperatedData/Testing/noVoiceCallsTest',fileNum,'.wav'),AveragedHPFnoVoiceCallsTest,fs);
        end
    catch exception
        throw(exception)
    end
end
