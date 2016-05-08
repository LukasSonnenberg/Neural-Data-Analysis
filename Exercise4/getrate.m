function [rate] = getrate(trace, h, n, x)

% Computes Wiener filter s.t. trace = conv(h,rate) + n, using x as an
% example of a ground truth signal to compute the filter with.

% we assume white noise and therefore N(f) = n for all f

% there are probably some sort of windowing issues...we should deal with
% this
window = length(trace);
wfun = hann(window);


H = real(fft(h)); %can I do this analytically?
X = real(fft(x));

G = (conj(H).*X)./((abs(H).^2).*X + n);
g = real(ifft(G)); % this is gonna be problematic I'm sure...

rate = conv(g,trace);
rate = rate(1:length(trace));