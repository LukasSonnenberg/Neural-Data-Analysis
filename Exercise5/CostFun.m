function [cost,width,psth] = CostFun(spikeTimes,stimOnsets,stimDuration,preStim,postStim)
%Cost function of different in widths. All given stimuli wil be counted as
%one and added together.
% cost: cost function
% width: array of used bin widhts
% psth: psth for each given bin width
% spikeTimes: times of all spikes independent of stimulus
% stimOnsets: times of onsets of stimuli
% stimDuration: lengt of stimulus in ms
% preStim: time before stimulus that is analyzed, too (ms)
% postStim: time after stimulus that is analyzed, too (ms)

n = length(stimOnsets);
width = 1:1:500; %bin witdths to test
N = floor((stimDuration+preStim+postStim)./width); %number of bins for each bin width
psth = cell(1,length(N)); % psth for each bin width

%variables for cost function
k = N*0;
v = N*0;

%% cost function
for i = 1:length(N)
    %edges of bins
    edges = -preStim:width(i):stimDuration+postStim;
    %psth
    psth{i} = PSTH(spikeTimes,stimOnsets,stimDuration,edges,preStim,postStim);
    %variables
    k(i) = mean(psth{i});
    v(i) = sum((psth{i}-k(i)).^2)/N(i);
end
%cost function
cost = (2*k-v)./(n*width).^2;