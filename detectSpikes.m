function [s, t] = detectSpikes(x, Fs)
% Detect spikes.
%   [s, t] = detectSpikes(x, Fs) detects spikes in x, where Fs the sampling
%   rate (in Hz). The outputs s and t are column vectors of spike times in
%   samples and ms, respectively. By convention the time of the zeroth
%   sample is 0 ms.

%get threshold
N = 1;
sigma = median(abs(x)/0.6745);
thresh = N*sigma;

%get all points below threshold
below_thresh = x<-thresh;

%get start and end of passover of threshold
