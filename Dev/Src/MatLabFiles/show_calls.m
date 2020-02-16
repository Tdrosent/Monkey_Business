 
function show_calls
global dataDir codeDir SR animalID

animalID='Colony';
% Adding paths to code and files
dataDir=char('.\Data'); 
codeDir=char('.\Production'); 
addpath(codeDir); 
addpath(dataDir);
fileNumber = char('010');

filename=strcat('STE-',fileNumber,'.wav'); %stimulus_a.wav

%get_calls(filename); 

segment_calls(filename); 


function segment_calls(filename)
global SR animalID
markerFile = open(strcat('marker_',fileNumber,'.mat'));
timeLocations = markerFile.all_markers_time;
Markers = markerFile.all_markers;

str_index=findstr(filename, '-'); 
str_index2=findstr(filename, '.');
call_data_file=strcat('data_', filename(str_index+1:str_index2-1)); 
load(call_data_file);  


viewTokens=1; % each token =1-min long recording
% ==== load the data
y_left=x_left_token(viewTokens,:); 
%y_right=x_right_token(viewTokens,:); 


% high-pass filter
hpFilt = designfilt('highpassiir','FilterOrder',8, 'PassbandFrequency',3000,'PassbandRipple',0.2, 'SampleRate',SR);
         

y_left2 = filtfilt(hpFilt,y_left);

h=figure;
set(h,'name',animalID); 


% ==== measure its spectrumgram
nFFT=512*4;
winLen=512*2; 
overlap=0.75;
win=window(@hamming,512*2);
[Y_left,F,T, Py_left] = spectrogram(y_left2,win,winLen*overlap, nFFT,SR,'MinThreshold',-100,'yaxis');

% === time vector
dur=length(y_left)/SR;
t=0:1/SR:dur-1/SR;


% time plot
subplot(2,1,1)
plot(t,y_left2, 'k');
axis([0 max(t) -max(abs(y_left)) max(abs(y_left))]);
set(gca, 'color', 'none','xtick', 0:5:60); 
%axis off

    title('amplitude') ; 

    xlabel('time (sec)');
    
% freq plot
subplot(2,1,2);
imagesc(T,F,10*log10(abs(Py_left)));
axis xy;
axis([0 max(T) 0 32000]);
set(gca, 'xtick', 0:5:60, 'ytick', 0:5000:30000); 


    title('spectrum'); 

    xlabel('time (sec)');
    ylabel('Frequency (kHz)')
   
colormap(jet);
%axis off


% === hear it
% pause;
%soundsc(y_left,SR); 



%=== save into wave file
% wavefilename='';
% wavwrite(y,SR,NBITS,wavefilename);



function get_calls(filename)
global SR dataDir
%call_len=60; % #sec recording                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
[x_total, SR]=audioread(strcat(dataDir,'\',filename)); % load the mysterious stimulus

dt=1000/SR; %ms
time=0:dt:(length(x_total)-1)*dt;

x_left=x_total(:,1);
x_right=x_total(:,2);
max_time= floor(time(end)/1000/60);  %  in minutes

segment_duration=30; %sec
overflow_duration=2; %sec

total_calltoken=max_time*60/segment_duration; % divide vector based on min
% each min of call is a token
for k=1:total_calltoken
    start_index=(k-1)*SR*segment_duration+1; 
    if k==total_calltoken
        
        end_index=k*SR*(segment_duration); 
        x_left_token(k,:)=zeros(1, size(x_left_token,2)); 
        x_left_token(k,1:(end_index-start_index+1))= x_left(start_index:end_index);
        
        %x_right_token(k,:)=zeros(1, size(x_right_token,2)); 
        %x_right_token(k,1:(end_index-start_index+1))= x_right(start_index:end_index);
       
    else
        end_index=k*SR*(segment_duration)+SR*overflow_duration; 
        x_left_token(k,:)= x_left(start_index:end_index);
        %x_right_token(k,:)= x_right(start_index:end_index);
        
    end
    
end

% str_index=findstr(filename, '-'); 
% str_index2=findstr(filename, '.');
% call_data_file=strcat('data_', filename(str_index+1:str_index2-1)); 
%save(call_data_file, 'x_left_token', 'x_right_token', 'SR', 'segment_duration', 'overflow_duration'); 



