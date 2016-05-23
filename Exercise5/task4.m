% load results from previous tasks
clear all
close all
set(0,'DefaultFigureWindowStyle','docked')

load NDA_task3_results
load NDA_stimulus

for i = 1 : numel(spikeTimes)
    plotRasters(spikeTimes{i}, stimulusOnset, direction, stimulusDuration)
    saveas(gcf, ['Ex1_', num2str(i)], 'pdf')
    plotPsth(spikeTimes{i}, stimulusOnset, direction, stimulusDuration)
    saveas(gcf, ['Ex2_', num2str(i)], 'pdf')
end

[KernelWidth,onset_cell] = plotOptimalPsth(spikeTimes, stimulusOnset, direction, stimulusDuration);
for i  = 1 : numel(spikeTimes)
    [ind] = linearityIndex(spikeTimes{i}, stimulusOnset(onset_cell{i}), stimulusDuration, KernelWidth(i))
    saveas(gcf, ['Ex4_', num2str(i)], 'pdf')
end
