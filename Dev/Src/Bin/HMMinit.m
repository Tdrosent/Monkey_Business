function HMMinit()
%% emission probabilities

% state order:

%1-nonVoice
%2-peep
%3-peep string
%4-phee
%5-trill
%6-tsik
%7-tsik string
%8-twitter
%9-combo

windowSize = 0.025*96000;
overlap = 0.4;
shift = floor(0.4*windowSize);


% initialize counters

nonvoiceCounter = 0;
peepCounter = 0;
peepstringCounter = 0;
pheeCounter = 0;
trillCounter = 0;
tsikCounter = 0;
tsikstringCounter = 0;
twitterCounter = 0;
comboCounter = 0;
nonvoiceCounterFrames = 0;
peepCounterFrames = 0;
peepstringCounterFrames = 0;
pheeCounterFrames = 0;
trillCounterFrames = 0;
tsikCounterFrames = 0;
tsikstringCounterFrames = 0;
twitterCounterFrames = 0;
comboCounterFrames = 0;


timeData010 = load('Models/newTimeData_010.mat');
timeData063 = load('Models/newTimeData_063.mat');
callData010 = load('Models/newCallData_010.mat');
callData063 = load('Models/newCallData_063.mat');


timeData1(:,1) = timeData010.newTimeData(:,1);
timeData1(:,2) = timeData010.newTimeData(:,2);
timeData2(:,1) = timeData063.newTimeData(:,1);
timeData2(:,2) = timeData063.newTimeData(:,2);

timeData = [timeData1;timeData2];

callData(:,1) = callData010.newCalls(:,:);
callData = [callData ;callData063.newCalls(:,:)];
sequence = [];

for i = 1:length(callData)
    callLength = timeData(i,2)-timeData(i,1);
    numFrames = ceil((callLength*96000)/(windowSize)+(callLength*96000*overlap)/windowSize);
    if strcmp('unvoiced',callData{i,:}) || strcmp('otherCall',callData{i,:})
        nonvoiceCounter = nonvoiceCounter+1;
        for j = 1:numFrames
            nonvoiceCounterFrames = nonvoiceCounterFrames+1;
            sequence = [sequence, 1];
        end
        
    elseif strcmp('peep',callData{i,:})
        peepCounter = peepCounter+1;
        for j = 1:numFrames
            peepCounterFrames = peepCounterFrames+1;
            sequence = [sequence, 2];
        end
        
    elseif strcmp('peep_string',callData{i,:})
        peepstringCounter = peepstringCounter+1;
        for j = 1:numFrames
            peepstringCounterFrames = peepstringCounterFrames+1;
            sequence = [sequence, 3];
        end
        
    elseif strcmp('phee',callData{i,:})
        pheeCounter = pheeCounter+1;
        for j = 1:numFrames
            pheeCounterFrames = pheeCounterFrames+1;
            sequence = [sequence, 4];
        end
    elseif strcmp('trill',callData{i,:})
        trillCounter = trillCounter+1;
        for j = 1:numFrames
            trillCounterFrames = trillCounterFrames+1;
            sequence = [sequence, 5];
        end
    elseif strcmp('tsik',callData{i,:})
        tsikCounter = tsikCounter+1;
        for j = 1:numFrames
            tsikCounterFrames = tsikCounterFrames+1;
            sequence = [sequence, 6];
        end
    elseif strcmp('tsik_string',callData{i,:})
        tsikstringCounter = tsikstringCounter+1;
        for j = 1:numFrames
            tsikstringCounterFrames = tsikstringCounterFrames+1;
            sequence = [sequence, 7];
        end
    elseif strcmp('twitter',callData{i,:})
        twitterCounter = twitterCounter+1;
        for j = 1:numFrames
            twitterCounterFrames = twitterCounterFrames+1;
            sequence = [sequence, 8];
        end
    elseif strcmp('combo',callData{i,:})
        comboCounter = comboCounter+1;
        for j = 1:numFrames
            comboCounterFrames = comboCounterFrames+1;
            sequence = [sequence, 9];
        end
    else 
        nonvoiceCounter = nonvoiceCounter+1;
         for j = 1:numFrames
            nonvoiceCounterFrames = nonvoiceCounterFrames+1;
            sequence = [sequence, 1];
        end
    end
end
% A total of 9 states coded 1-9 correspond to a single emission each, with
% a probability of producing that emission equaling 1, and a 0 chance of
% producing any of the other 8 emissions.

v = ones(1,9);
emissionsProb = diag(v);

TransGuess = ones(length(emissionsProb)).*(1/(length(emissionsProb)^2));

% train HMM

% [TRANS_EST, EMIS_EST] = hmmtrain(sequence, TransGuess, emissionsProb);

% save(strcat('Models/','HMMTransProbs_windowSize_', num2str(windowSize/96),'ms' ,'.mat'),'TRANS_EST');
save(strcat('Models/','StateSequence_windowSize_', num2str(windowSize/96),'ms' ,'.mat'),'sequence');


end