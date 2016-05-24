function counts = getSpikeCounts(spikeTimes, stimOnsets, directions, stimDuration)
% Get firing rate matrix for stimulus presentations.
%   counts = getSpikeCounts(spikeTimes, stimOnsets, directions, stimDuration)
%   Inputs:
%       spikeTimes      vector of spike times           #spikes x 1
%       stimOnsets      vector of stimulus onset times (one per trial)
%                                                       #trials x 1
%       directions      vector of stimulus directions (one per trial)
%                                                       #trials x 1
%       stimDuration    duration of stimulus presentation in ms
%                                                       scalar
%   Output: 
%   counts      matrix of spike counts during stimulus presentation. The
%               matrix has dimensions #trials/direction x #directions


dirs = unique(directions);
counts = zeros(sum(directions == dirs(1)),length(dirs));

for j = 1:length(dirs)
    onset = stimOnsets(directions == dirs(j));
    for k = 1:length(onset)
        counts(k,j) = sum(spikeTimes(spikeTimes>onset(k) & spikeTimes<onset(k)+stimDuration));
    end
end