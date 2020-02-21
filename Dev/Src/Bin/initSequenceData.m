%function [] = initSequenceData(input,windowSize,overlap)
sequence = {};

blkStart = 1;
blkEnd = windowSize;
if  overlap == 0
    shift = windowSize;
else
    shift = windowSize * overlap;
end

DataLoc = char('./Data');
fileTypes = char('/*.wav');
addpath(DataLoc)

tempStruct = dir(strcat(DataLoc,fileTypes));

counter1 = 0;
counter2 = 0;
counter3 = 0;
counter4 = 0;
counter5 = 0;
counter6 = 0;
counter7 = 0;
counter8 = 0;
counter9 = 0;
counterAll = 0;

for i = 1:length({tempStruct.name})
    fileNames(i) = {tempStruct(i).name};
    FileNum(i) = {fileNames{i}(end-6:end-4)};
end
newTimeData = [];
newCalls = {};

for k = 1:length({tempStruct.name})
    MarkerData = open(strcat('Marker_',FileNum{k},'.mat'));
    TimeData = MarkerData.all_markers_time;
    Call = MarkerData.all_markers;
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
    [Audio, Fs] = audioread(fileNames{k});
    
    for i = 1:length(TimeData)
        StartIndex = floor(Fs*TimeData(i,1));
        StopIndex  = floor(Fs*TimeData(i,2));
        %Found one weird annomoly in 063 index 36 where Stop < Start
        if StartIndex > StopIndex
            continue
        end
        Data = Audio(StartIndex:StopIndex,:);
        if (strcmp(Call{i},'combo'))
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
    for i = 1:length(TimeData)
        endFlag = 0;
        StartIndex = floor(Fs*TimeData(i,1));
        if i > 1
            StopIndex  = floor(Fs*TimeData(i-1,2));
        end
        if i == 1
            startNoVoice = 1;
            stopNoVoice = StartIndex;
        else
            startNoVoice = StopIndex;
            stopNoVoice = StartIndex;
        end
        %Found one weird annomoly in 063 index 36 where Stop < Start
        if startNoVoice > stopNoVoice
            continue
        end
        
        if i == length(TimeData)
            startNoVoice = StopIndex;
            endFlag = 1;
        end
        if ~endFlag
            Data = Audio(startNoVoice:stopNoVoice,:);
            Counter = nonVoice;
            nonVoice = nonVoice +1;
            audiowrite(strcat('./TrainingData/',FileNum{k},'_',num2str(Counter),'_','nonVoice','.wav'),Data,Fs);
        else
            Data = Audio(startNoVoice:end,:);
            Counter = nonVoice;
            nonVoice = nonVoice +1;
            audiowrite(strcat('./TrainingData/',FileNum{k},'_',num2str(Counter),'_','nonVoice','.wav'),Data,Fs);
        end
    end
    
end





