function [cost,width,psth] = CostFun(spikeTimes,stimOnsets,stimDuration,preStim,postStim)
n = length(stimOnsets);
width = 1:1:500;
N = floor((stimDuration+preStim+postStim)./width);

k = N*0;
v = N*0;
psth = cell(1,length(N));

for i = 1:length(N)
    edges = -preStim:width(i):stimDuration+postStim;
    psth{i} = PSTH(spikeTimes,stimOnsets,stimDuration,edges,preStim,postStim);
    k(i) = mean(psth{i});
    v(i) = sum((psth{i}-k(i)).^2)/N(i);
end

cost = (2*k-v)./(n*width).^2;