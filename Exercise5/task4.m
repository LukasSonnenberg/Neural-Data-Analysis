% load results from previous tasks
clear all
close all
set(0,'DefaultFigureWindowStyle','docked')

load NDA_task3_results
load NDA_stimulus

for i = 1 : numel(spikeTimes)
    %plotRasters(spikeTimes{i}, stimulusOnset, direction, stimulusDuration)
    plotPsth(spikeTimes{i}, stimulusOnset, direction, stimulusDuration)
end

plotOptimalPsth(spikeTimes, stimulusOnset, direction, stimulusDuration)

