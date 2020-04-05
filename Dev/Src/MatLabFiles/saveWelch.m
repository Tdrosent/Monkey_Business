function saveWelch(H, W)
path = '../../../../';
dataDir = 'CleanedData/';
folder = 'RawFiles';
folderDir = strcat(dataDir,folder);
callName = 'trillCallsTrain';
pass = ''; % Put '' for no omlsa, '-SecondPass' for second pass

saveDir = strcat(path,'trunk/Docs/Pictures');
if ~exist(strcat(saveDir,'/PSD_Welch/',folder))
   mkdir(strcat(saveDir,'/PSD_Welch/',folder))
end
saveDir = strcat(saveDir,'/PSD_Welch/',folder,'/');

num1 = '006';
num2 = '008';
num3 = '010';
num4 = '063';
fileExt = '.wav';

[call1,freq3] = audioread(strcat(path,folderDir,'/',callName,num1,pass,fileExt));
[call2,freq4] = audioread(strcat(path,folderDir,'/',callName,num2,pass,fileExt));
[call3,freq5] = audioread(strcat(path,folderDir,'/',callName,num3,pass,fileExt));
[call4,freq6] = audioread(strcat(path,folderDir,'/',callName,num4,pass,fileExt));

figure()
pwelch(call1,round(length(call1)/W),[],'onesided');
saveas(gcf,strcat(saveDir,callName,num1,pass,'_PSD_Welch','.png'));

figure()
pwelch(call2,round(length(call2)/W),[],'onesided');
saveas(gcf,strcat(saveDir,callName,num2,pass,'_PSD_Welch','.png'));

figure()
pwelch(call3,round(length(call3)/W),[],'onesided');
saveas(gcf,strcat(saveDir,callName,num3,pass,'_PSD_Welch','.png'));

figure()
pwelch(call4,round(length(call4)/W),[],'onesided');
saveas(gcf,strcat(saveDir,callName,num4,pass,'_PSD_Welch','.png'));
end