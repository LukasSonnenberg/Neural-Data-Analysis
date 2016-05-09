function [Ca] = Ca_func(spikes, offset, A, b, window, sr)
% a funtion to model the calcium traces, modelled  as convolution
% with exponential function of form A*exp(-x/b)+offset
% window is in seconds
% sr is sampling rate
% generate the filter 

t = linspace(0,window,floor(window*sr));
Ca = conv(A*exp(-t./b), sqrt(spikes));
Ca = Ca + offset;
Ca = Ca(1:length(spikes));
