function psth = PSTH(spikeTimes,stimOnsets,stimDuration,edges,preStim,postStim)

psth = zeros(1,length(edges)-1);
for j = 1:length(stimOnsets)
    spikes = spikeTimes(spikeTimes>stimOnsets(j)-preStim...
        & spikeTimes<stimOnsets(j)+stimDuration+postStim);
    psth = psth + histcounts(spikes-stimOnsets(j),edges);
end