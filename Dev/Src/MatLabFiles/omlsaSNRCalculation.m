% Utility script to calculate the SNR of a wav file before and after MCRA

%Defining some parameters used to generate Spectrogram
W = 4096; %window size
win = window(@blackmanharris,W);
noverlap = W/2;

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
               
%Name of calls in order
CallNames = {'Combo',...
             'no Voice',...
             'Peep',...
             'Phee',...
             'Trill',...
             'Tsik',...
            };

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
    [orignal,Fs] = audioread([List1{i},'.wav']);
    [After,~]   = audioread([List2{i},'.wav']);
    
    origSNR = snr(orignal);
    AfterSNR = snr(After);
    dif = abs(AfterSNR - origSNR);
    fprintf(fid,"%s SNR: %f,\n %s SNR: %f,\n improvement: %f\n\n", List1{i}, origSNR, List2{i},AfterSNR,dif);
    
    plots=figure();
    set(0,'DefaultFigureVisible','off');
    subplot(2,1,1);
    [~,freq_original,time_original,psd_original]=spectrogram(orignal,win,noverlap,W,Fs,'yaxis');
    surf(time_original,freq_original,10*log10(psd_original),'edgecolor','none');
    axis tight; view(0,90);
    title({strcat(CallNames{i},'-063'),strcat('Original Call: SNR =', num2str(origSNR),'dB')});
    xlabel('Time (s)'); ylabel('Frequency (Hz)'); h = colorbar; ylabel(h, 'dB'); colormap winter;
    
    subplot(2,1,2);
    [~,freq_After,time_After,psd_After]=spectrogram(After,win,noverlap,W,Fs,'yaxis');
    surf(time_After,freq_After,10*log10(psd_After),'edgecolor','none');
    axis tight; view(0,90);
    title({strcat('After OMLSA: SNR =', num2str(AfterSNR),'dB'),strcat("Improvement = ", num2str(dif),'dB')});
    xlabel('Time (s)'); ylabel('Frequency (Hz)'); h = colorbar; ylabel(h, 'dB'); colormap winter;
    
    saveas(plots,strcat(List2{i},'.tiff'));

end
fclose(fid);













