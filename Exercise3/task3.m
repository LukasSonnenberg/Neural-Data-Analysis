% load data from task 2
clear all
close all
set(0,'DefaultFigureWindowStyle','docked')

load NDA_task1_results
load NDA_task2_results

% diagnostic plots
%plotWaveforms(w, assignments)
plotCCG(t, assignments)
%plotSeparation(b, mu, Sigma, priors, assignments)
