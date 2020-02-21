addpath('./Data');

[Audio1,Fs] = audioread('STE-010-Train.wav');
[Audio2,Fs] = audioread('STE-063-Train.wav');

newAudio = [Audio1 ; Audio2];

audiowrite('./Data/CombinedCalls010063.wav',newAudio,Fs);

marker10 = load('marker_010-Train.mat');
marker63 = load('marker_063-Train.mat');

%Adding in unvoiced markers and their associated time indecies
for k = 1:2
    newTimeData = [];
    newCalls = {};
    if k == 1
        TimeData = marker10.all_markers_time;
        Call = marker10.all_markers;
    else
        TimeData = marker63.all_markers_time;
        Call = marker63.all_markers;
    end
        lengthTimeData = length(TimeData);
    while true
        %verifying that the times look right, there are no times that the
        %end is greater than the begining
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
    if k == 1
        newCalls010 = newCalls';
        newTime010 = newTimeData;
    else
        newCalls063 = newCalls';
        %Need to adjust the start time of 063 because we are appending it
        %to the end of 010. By adding the last time value in 010 this
        %should fix it
        newTime063 = newTimeData+newTime010(end);
    end
end

trainMarkers = [ newCalls010;newCalls063];

timeData = [newTime010;newTime063];

TrainingMarkers.all_markers = trainMarkers;
TrainingMarkers.all_markers_time = timeData;

save('./Data/CombinedCalls01063-Train.mat','TrainingMarkers');
