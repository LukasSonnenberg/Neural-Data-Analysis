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
params = zeros(n,4,2);
cos_tun = zeros(n,length(dirs));

for i = 1:n
    counts(i,:,:) = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration);
    params(i,:,1) = fitLS(dirs,squeeze(counts(i,:,:)));
    params(i,:,2) = fitML(dirs,squeeze(counts(i,:,:)));
    cos_tun(i,:) = fitCos(dirs,squeeze(counts(i,:,:)));
%     p(i) = testTuning(dirs, counts);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(p < 0.01), n)

% plot a few nice ones
PlotSpikeCounts(dirs,counts,squeeze(params(:,:,1)),cos_tun,[6 18 20 21 23 24 28 29 37])

PlotSpikeCounts(dirs,counts,squeeze(params(:,:,2)),cos_tun,[6 18 20 21 23 24 28 29 37])
%PlotSpikeCounts(dirs,counts,params)
