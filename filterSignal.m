function y = filterSignal(x, Fs)
% Filter raw signal
%   y = filterSignal(x, Fs) filters the signal x. Each column in x is one
%   recording channel. Fs is the sampling frequency. The filter delay is
%   compensated in the output y.

%% Overall noise
%usually the same in all channels
% -> sbstract the mean of each timestep
%y1 = bsxfun(@minus,x,mean(x,2)); 

%% Lowpass
%smoothing of the curve
WindowSize = Fs/(10^4);
y2 = filter(ones(1,WindowSize)/WindowSize,1,x);

%% Highpass
%with a barrier frequency tau [s]
tau = 1e-4;
a =1/(Fs*tau);
y3 = filter([1-a a-1], [1 a-1], y2);

y = y3;