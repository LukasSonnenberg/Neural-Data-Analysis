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

% get orientations
orientations = unique(directions);
for i = 1:length(orientations)
   times{i} = find(directions == orientations(i)); 
end

figure;
for i = 1:length(orientations)
   subplot(4,4,i);
   hold on;
   nspikes = 0;
   for j = 1:length(times{i})
    spikes = spikeTimes((spikeTimes > (stimOnsets(times{i}(j))-preStim)) & (spikeTimes < (stimOnsets(times{i}(j))+stimDuration + postStim)));
    plot(spikes-stimOnsets(times{i}(j)),j*0.1*ones(length(spikes),1),'k.');
    nspikes = nspikes + length(spikeTimes((spikeTimes > stimOnsets(times{i}(j))) & (spikeTimes < (stimOnsets(times{i}(j))+stimDuration ))));
   end
   fprintf('Number of spikes for orientation %.2f: %d\n',orientations(i),nspikes);
   title(num2str(orientations(i)));
   xlim([-500 2500]);
   ylim([0 length(times{i})*0.1+0.2]);
   plot([0 stimDuration stimDuration 0 0], [0 0 1 1 0 ]*(length(times{i})*0.1+0.2));
   
end