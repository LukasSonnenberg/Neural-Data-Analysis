function psth = PSTH(spikeTimes,stimOnsets,stimDuration,edges,preStim,postStim)
%get PSTH at imes of stimuli. All given stimuli will be
%counted as the same stimulus and added together
% psth: PSTH
% spikeTimes: times of all spikes independent of stimulus
% stimOnsets: times of onsets of stimuli
% stimDuration: lengt of stimulus in ms
% edges: edges of bins of PSTH
% preStim: time before stimulus that is analyzed, too (ms)
% postStim: time after stimulus that is analyzed, too (ms)


psth = zeros(1,length(edges)-1);
for j = 1:length(stimOnsets)
    %get spiketimes for this stimulus
    spikes = spikeTimes(spikeTimes>stimOnsets(j)-preStim...
        & spikeTimes<stimOnsets(j)+stimDuration+postStim);
    %add together the spikes over each bin 
    psth = psth + histcounts(spikes-stimOnsets(j),edges);
end