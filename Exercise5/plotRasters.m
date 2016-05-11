function plotRasters(spikeTimes, stimOnsets, directions, stimDuration)
% Plot spike rasters.
%   plotRasters(spikeTimes, stimOnsets, directions, stimDuration) plots the
%   spike rasters for one single unitfor all 16 stimulus conditons. Inputs
%   are:
%       spikeTimes      vector of spike times           #spikes x 1
%       stimOnsets      vector of stimulus onset times (one per trial)
%                                                       #trials x 1
%       directions      vector of stimulus directions (one per trial)
%                                                       #trials x 1
%       stimDuration    duration of stimulus presentation in ms
%                                                       scalar

% plotting parameters
preStim = 500;
postStim = 500;
