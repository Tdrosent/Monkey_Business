function snrComparison(audioInPath1, audioInPath2, H, W)

[audioIn1,freq1] = audioread(audioInPath1);
[audioIn2,freq2] = audioread(audioInPath2);

[Pxx1,f1] = pwelch(audioIn1,round(length(audioIn1)/W),[],'onesided');
[Pxx2,f2] = pwelch(audioIn2,round(length(audioIn2)/W),[],'onesided');

SNR1 = snr(Pxx1,f1,H,'psd');
SNR2 = snr(Pxx2,f2,H,'psd');

sprintf('SNR before OMLSA: %.3f', SNR1)
sprintf('SNR after OMSLA: %.3f', SNR2)

end

