% Utility script to calculate the SNR of a wav file before and after MCRA

%Defining some parameters used to generate Spectrogram
W = 4096; %window size
win = window(@blackmanharris,W);
noverlap = W/2;

%Datapath to the realative wav file location
datapath1 = char('../../../Data/OMSLA-SNR-Calculation-Files/');
datapath2 = char('../../../Data/OMSLA-SNR-Calculation-Files/After/FirstPass/');
datapath3 = char('../../../Data/OMSLA-SNR-Calculation-Files/After/SecondPass/');
Results   = char('../../../Data/OMSLA-SNR-Calculation-Files/After/');
PlotsPath = char('../../../Data/OMSLA-SNR-Calculation-Files/After/Plots');

%Experiment numbers to process 
FileNames = { 'twitterCallsTrain063-Before-OMLSA',...
              'comboCallsTrain063-Before-OMSLA',...;
              'noVoiceCallsTrain063-Before-OMSLA',...
              'peepCallsTrain063-Before-OMSLA',...
              'pheeCallsTrain063-Before-OMSLA',...
              'trillCallsTrain063-Before-OMSLA',...
              'tsikCallsTrain063-Before-OMSLA'};
         
%Experiment numbers to process 
FileNamesOutput = {'twitterCallsTrain063-After-OMSLA',...
                   'comboCallsTrain063-After-OMSLA',...
                   'noVoiceCallsTrain062-After-OMSLA',...
                   'peepCallsTrain063-After-OMSLA',...
                   'pheeCallsTrain063-After-OMSLA',...
                   'trillCallsTrain063-After-OMSLA',...
                   'tsikCallsTrain063-After-OMSLA'};
%Experiment numbers to process 
FileNamesOutput2 = {'twitterCallsTrain063-After-OMSLA-2',...
                    'comboCallsTrain063-After-OMSLA-2',...
                    'noVoiceCallsTrain062-After-OMSLA-2',...
                    'peepCallsTrain063-After-OMSLA-2',...
                    'pheeCallsTrain063-After-OMSLA-2',...
                    'trillCallsTrain063-After-OMSLA-2',...
                    'tsikCallsTrain063-After-OMSLA-2'};
               
%Name of calls in order
CallNames = {'Twitter',...
             'Combo',...
             'noVoice',...
             'Peep',...
             'Phee',...
             'Trill',...
             'Tsik',...
            };

%Initalizing a cell to hold path & wav file names to push down into OMSLA
List1 = cell(length(FileNames),1);
List2 = cell(length(FileNames),1);
List3 = cell(length(FileNames),1);
for i = 1:length(FileNames)
    List1{i} = strcat(datapath1,FileNames{i});
    List2{i} = strcat(datapath2,FileNamesOutput{i});
    List3{i} = strcat(datapath3, FileNamesOutput2{i});
end

% Calling OMSLA for all files
for i=1:length(FileNames)
    omlsa(List1{i},List2{i});
    omlsa(List2{i},List3{i});
end

%Opening a text file to place the SNR results before and after
fid = fopen(strcat(Results,'OMSLA-SNR-Before-and-After.txt'),'w');

for i =1:length(FileNames)
    [orignal,Fs]    = audioread([List1{i},'.wav']);
    [AfterOnce,~]   = audioread([List2{i},'.wav']);
    [AfterTwice,~]  = audioread([List3{i},'.wav']);

    origSNR = snr(orignal);
    AfterOnceSNR = snr(AfterOnce);
    AfterTwiceSNR = snr(AfterTwice);
    dif1 = abs(AfterOnceSNR - origSNR);
    dif2 = abs(AfterTwiceSNR - origSNR);
    
    fprintf(fid,"%s SNR: %f,\n %s SNR: %f,\n %s SNR: %f,\n improvement(First pass): %f\n improvement(Second pass): %f\n\n",...
               List1{i}, origSNR, List2{i},AfterOnceSNR,List3{i},AfterTwiceSNR,dif1,dif2);
    
    plots=figure();
    set(0,'DefaultFigureVisible','off');
    subplot(3,1,1);
    [~,freq_original,time_original,psd_original]=spectrogram(orignal,win,noverlap,W,Fs,'yaxis');
    surf(time_original,freq_original,10*log10(psd_original),'edgecolor','none');
    axis tight; view(0,90);
    title({strcat(CallNames{i},'-063'),strcat('Original Call: SNR =', num2str(origSNR),'dB')});
    xlabel('Time (s)'); ylabel('Frequency (Hz)'); h = colorbar; ylabel(h, 'dB'); colormap winter;
    
    subplot(3,1,2);
    [~,freq_After,time_After,psd_After]=spectrogram(AfterOnce,win,noverlap,W,Fs,'yaxis');
    surf(time_After,freq_After,10*log10(psd_After),'edgecolor','none');
    axis tight; view(0,90);
    title({strcat('After OMLSA: SNR =', num2str(AfterOnceSNR),'dB'),strcat("Improvement = ", num2str(dif1),'dB')});
    xlabel('Time (s)'); ylabel('Frequency (Hz)'); h = colorbar; ylabel(h, 'dB'); colormap winter;
    
    subplot(3,1,3);
    [~,freq_AfterTwice,time_AfterTwice,psd_AfterTwice]=spectrogram(AfterTwice,win,noverlap,W,Fs,'yaxis');
    surf(time_AfterTwice,freq_AfterTwice,10*log10(psd_AfterTwice),'edgecolor','none');
    axis tight; view(0,90);
    title({strcat('After OMLSA (2nd Run): SNR =', num2str(AfterTwiceSNR),'dB'),strcat("Improvement = ", num2str(dif2),'dB')});
    xlabel('Time (s)'); ylabel('Frequency (Hz)'); h = colorbar; ylabel(h, 'dB'); colormap winter;
    
    saveas(plots,strcat(PlotsPath,'/',CallNames{i},'_OMLSA_Spectrogram','.png'));

end
fclose(fid);













