function TestTrainDecomposition()
DataLoc = char('./Data');
fileTypes = char('/*.wav');
addpath(DataLoc)

tempStruct = dir(strcat(DataLoc,fileTypes));
for i = 1:length({tempStruct.name})
    fileNames(i) = {tempStruct(i).name};
    FileNum(i) = {fileNames{i}(end-6:end-4)};
end

for k = 1:length({tempStruct.name})
    [Audio, Fs] = audioread(fileNames{k});
    TestNameAudio = strcat('./Test/STE-',FileNum{k},'-Test.wav');
    TrainNameAudio = strcat('./Data/STE-',FileNum{k},'-Train.wav');
    
    TestNameMarkers = strcat('./Test/marker_',FileNum{k},'-Test.mat');
    TrainNameMarkers = strcat('./Data/marker_',FileNum{k},'-Train.mat');
    
    MarkerData = open(strcat('Marker_',FileNum{k},'.mat'));
    TimeData = MarkerData.all_markers_time;
    Call = MarkerData.all_markers;
    
    % Sort time stamps in ascending order
    sorter = {};
    sorted = {};
    sorter(:,1) = num2cell(TimeData(:,1));
    sorter(:,2) = num2cell(TimeData(:,2));
    sorter(:,3) = Call;
    sorted = sortrows(sorter,1);
    TimeData(:,1) = cell2mat((sorted(:,1)));
    TimeData(:,2) = cell2mat((sorted(:,2)));
    Call = sorted(:,3);
    

    %This will find the closest call to 6 mins
    TimeLength = length(Audio)/Fs;
    
    StartIndexTest = find(TimeData(:,1) > TimeLength-300,1);
    
    
    MarkerDataTest.all_markers = Call(StartIndexTest:end,:);
    MarkerDataTest.all_markers_time = TimeData(StartIndexTest:end,:)-TimeData(StartIndexTest,1);
    
    MarkerDataTrain.all_markers = Call(1:StartIndexTest-1,:);
    MarkerDataTrain.all_markers_time = TimeData(1:StartIndexTest-1,:);
    
    
    StartSampleTest = floor(TimeData(StartIndexTest,1)*Fs);
    
    TestData = Audio(StartSampleTest:end,:);
    TrainData = Audio(1:StartSampleTest-1,:);
    
    audiowrite(TestNameAudio,TestData,Fs);
    audiowrite(TrainNameAudio,TrainData,Fs);
    save(TestNameMarkers,'-struct','MarkerDataTest');
    save(TrainNameMarkers,'-struct','MarkerDataTrain');
end