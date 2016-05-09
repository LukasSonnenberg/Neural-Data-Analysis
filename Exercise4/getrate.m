function [rate] = getrate(trace, h)

% Computes deconvolution.

H = fft(h'); %can I do this analytically?
%N = periodogram(n,[],wlen);
%Yper = periodogram(trace,[],wlen);
Y = real(fft(trace')); % why does windowing make things worse?
G = 1./H;% .* (Yper - 0.1)./ Yper; %% ok that wasn't working no wiener filter
rate = real(ifft(G.*Y(1:length(G))));
rate = rate(1:length(trace));