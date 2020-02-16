function grepTestingData()
DataLoc = char('./Test');
fileTypes = char('/*Test.wav');
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
    FileNum(i) = {fileNames{i}(end-11:end-9)};
end

for k = 1:length({tempStruct.name})
    %     [Audio, Fs] = audioread(fileNames{k});
    MarkerData = open(strcat('Marker_',FileNum{k},'-Test.mat'));
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
    
    save(strcat('./Test/','newTimeData_',FileNum{k},'.mat'),'newTimeData');
    save(strcat('./Test/','newCallData_',FileNum{k},'.mat'),'newCalls');
end
