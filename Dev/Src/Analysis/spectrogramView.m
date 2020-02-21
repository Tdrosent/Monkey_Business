function spectrogramView(wavPath)
window   = hamming(512);
noverlap =256;
nfft     =1024;
[audio,f]=audioread(wavPath);

mixed = 1/2*(audio(:,1)+audio(:,2));

[~,freq_sa2,time_sa2,psd_sa2]=spectrogram(mixed,window,noverlap,nfft,f,'yaxis');
surf(time_sa2,freq_sa2,10*log10(psd_sa2),'edgecolor','none');
axis tight; view(0,90);
title('Original Signal sa2')
xlabel('Frequency (Hz)'); ylabel('amplitude'); h = colorbar; ylabel(h, 'dB'); colormap winter;