%% Grep Training Data
%   This functions purpose is to load in each file that we have of training
%   and markers. It will parse through the the markers and their associated
%   times and create new .wav files with the following name format
%   "Num_Instance_CallName.wav" where CallName is the phoneme spoken,
%   Instance is the number of times that it has been spoken, and Num is the
%   file number associated with it

function grepTrainingData()
DataLoc = char('./Data');
fileTypes = char('/*Train.wav');
if ~exist(DataLoc,'file')
    Error('Data folder does not exist')
end
if ~exist('TrainingData','file')
    mkdir('TrainingData');
end
addpath(DataLoc)
tempStruct = dir(strcat(DataLoc,fileTypes));
for i = 1:length({tempStruct.name})
    fileNames(i) = {tempStruct(i).name};
    FileNum(i) = {fileNames{i}(end-12:end-10)};
end



for k = 1:length({tempStruct.name})
    [Audio, Fs] = audioread(fileNames{k});
    MarkerData = open(strcat('Marker_',FileNum{k},'-Train.mat'));
    TimeData = MarkerData.all_markers_time;
    Call = MarkerData.all_markers;
    newTimeData = [];
    newCalls = {};
    lengthTimeData = length(TimeData);
    % Add "nonVoiced sounds as a class
    while true
        for i = 1:lengthTimeData - 1
            if TimeData(i,2) < TimeData(i,1)
                TimeData(i,:) = NaN;
                Call{i} = 'NaN';
            end
        end
        if max(isnan(TimeData(:,1))) == 0
            break
        end
        TimeData = TimeData(~isnan(TimeData(:,1)),:);
        CallIndex = find(cellfun('length',regexp(Call,'^NaN$')) ~= 1);
        Call = Call(CallIndex);
        lengthTimeData = length(TimeData);
    end

    for i = 1:length(TimeData)
        if i ==1
            if TimeData(i,1) ~= 0              
                newTimeData(i,1) = 0;
                newTimeData(i,2) = TimeData(i,1);
                newCalls{end+1} = 'unvoiced';
                
                newTimeData = [newTimeData;TimeData(i,1),TimeData(i,2)];
                newCalls{end+1} = Call{i};
                
            else
                newTimeData(i,1) = TimeData(i,1);
                newTimeData(i,2) = TimeData(i,2);
                newCalls{end+1} = Call{i};
            end
            if TimeData(i,2) ~= TimeData(i+1,1)
                newTimeData = [newTimeData;TimeData(i,2),TimeData(i+1,1)];
                newCalls{end+1} = 'unvoiced';
            end
        else
            
            
            if i ~= length(TimeData) && TimeData(i,2) ~= TimeData(i+1,1)                
                newTimeData = [newTimeData;TimeData(i,1),TimeData(i,2)];
                newCalls{end+1} = Call{i};
                
                newTimeData = [newTimeData;TimeData(i,2),TimeData(i+1,1)];
                newCalls{end+1} = 'unvoiced';
            else
                newTimeData = [newTimeData;TimeData(i,1),TimeData(i,2)];
                newCalls{end+1} = Call{i};
            end
        end
    end
    newCalls = newCalls';
    
    combo =0;
    peep =0;
    peep_string =0;
    phee =0;
    trill =0;
    tsik =0;
    tsik_string =0;
    twitter =0;
    nonVoice = 0;
    Counter =0;
    
    TimeData = newTimeData;
    Call = newCalls;
    for i = 1:length(TimeData)
        StartIndex = floor(Fs*TimeData(i,1));
        StopIndex  = floor(Fs*TimeData(i,2));
        if StartIndex == 0
            StartIndex = 1;
        end
        %Found one weird annomoly in 063 index 36 where Stop < Start
        if StartIndex > StopIndex
            continue
        end
        Data = Audio(StartIndex:StopIndex,:);
        if (strcmp(Call{i},'unvoiced'))
            Counter = nonVoice;
            nonVoice = nonVoice +1;
            
        elseif (strcmp(Call{i},'combo'))
            Counter = combo;
            combo = combo +1;

        elseif (strcmp(Call{i},'otherCall'))
            continue
        elseif (strcmp(Call{i},'peep'))
            Counter = peep;
            peep = peep +1;

        elseif (strcmp(Call{i},'peep_string'))
            Counter = peep_string;
            peep_string = peep_string+1;

        elseif (strcmp(Call{i},'phee'))
            Counter = phee;
            phee = phee +1;

        elseif (strcmp(Call{i},'trill'))
            Counter = trill;
            trill = trill +1;

        elseif (strcmp(Call{i},'tsik'))
            Counter = tsik;
            tsik = tsik+1;

        elseif (strcmp(Call{i},'tsik_string'))
            Counter = tsik_string;
            tsik_string = tsik_string+1;

        elseif (strcmp(Call{i},'twitter'))
            Counter = twitter;
            twitter = twitter +1;

        elseif (strcmp(Call{i},'WRONG'))
            continue
        end
        audiowrite(strcat('./TrainingData/',FileNum{k},'_',num2str(Counter),'_',Call{i},'.wav'),Data,Fs);
    end

    
    %% Save data
    
    save(strcat('./Models/','newTimeData_',FileNum{k},'.mat'),'newTimeData');
    save(strcat('./Models/','newCallData_',FileNum{k},'.mat'),'newCalls');
end

end





