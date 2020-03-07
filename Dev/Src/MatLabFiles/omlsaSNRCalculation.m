% Utility script to calculate the SNR of a wav file before and after MCRA

%Datapath to the realative wav file location
datapath1 = char('../../../Data/OMSLA-SNR-Calculation-Files/');
datapath2 = char('../../../Data/OMSLA-SNR-Calculation-Files/After/');

%Experiment numbers to process 
FileNames = {'comboCallsTrain063-Before-OMSLA',...
             'noVoiceCallsTrain063-Before-OMSLA',...
             'peepCallsTrain063-Before-OMSLA',...
             'pheeCallsTrain063-Before-OMSLA',...
             'trillCallsTrain063-Before-OMSLA',...
             'tsikCallsTrain063-Before-OMSLA'};
         
         %Experiment numbers to process 
FileNamesOutput = {'comboCallsTrain063-After-OMSLA',...
                   'noVoiceCallsTrain062-After-OMSLA',...
                   'peepCallsTrain063-After-OMSLA',...
                   'pheeCallsTrain063-After-OMSLA',...
                   'trillCallsTrain063-After-OMSLA',...
                   'tsikCallsTrain063-After-OMSLA'};

%Initalizing a cell to hold path & wav file names to push down into OMSLA
List1 = cell(length(FileNames),1);
List2 = cell(length(FileNames),1);
for i = 1:length(FileNames)
    List1{i} = strcat(datapath1,FileNames{i});
    List2{i} = strcat(datapath2,FileNamesOutput{i});
end

% Calling OMSLA for all files
for i=1:length(FileNames)
    omlsa(List1{i},List2{i});
end

%Opening a text file to place the SNR results before and after
fid = fopen(strcat(datapath2,'OMSLA-SNR-Before-and-After.txt'),'w');

for i =1:length(FileNames)
    [orignal,~] = audioread([List1{i},'.wav']);
    [After,~]   = audioread([List2{i},'.wav']);
    
    origSNR = snr(orignal);
    AfterSNR = snr(After);
    dif = abs(AfterSNR - origSNR);
    fprintf(fid,"%s SNR: %f,\n %s SNR: %f,\n improvement: %f\n\n", List1{i}, origSNR, List2{i},AfterSNR,dif);
end
fclose(fid);













