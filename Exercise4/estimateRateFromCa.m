function [inferredRate] = estimateRateFromCa(trace)
trace=double(trace);
% mean fps from given data
fps = 11.5;
cutoff = 2;
% low pass trace (cutoff set somewhat haphazardly)
% low pass
[a,b] = butter(6,cutoff*2/fps,'low');
ftrace = filtfilt(a,b,trace);

% apply iterative averaging
ftrace = LocAv(ftrace,0.1,2e3);

% Compute deconvolution using impulse response with learned parameters
A = mean(trace);
b=0.6; %estimated from data
t = [1:length(ftrace)]/fps;
h = A*exp(-t./b);
inferredRate = getrate(ftrace', h);
