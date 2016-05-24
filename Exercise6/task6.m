% load data
clear all
close all
set(0,'DefaultFigureWindowStyle','docked')

load NDA_task6_data
load NDA_stimulus

% test for significant tuning
dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);
counts = zeros(n,sum(direction == dirs(1)),length(dirs));

for i = 1 : n
    counts(i,:,:) = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration);
%     p(i) = testTuning(dirs, counts);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(p < 0.01), n)
PlotSpikeCounts(dirs,counts)
% plot a few nice ones
