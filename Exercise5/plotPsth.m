function plotPsth(spikeTimes, stimOnsets, directions, stimDuration)
% Plot peri-stimulus time histograms (PSTH).
%   plotPsth(spikeTimes, stimOnsets, directions, stimDuration) plots the
%   PSTHs for one single unit for all 16 stimulus conditons. Inputs are:
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

bin_width = 20;
stims = unique(directions);
bin_count = (preStim+postStim+stimDuration)/bin_width;
edges = -preStim:bin_width:stimDuration+postStim;
centers = linspace(mean(edges(1:2)),mean(edges(end-1:end)),length(edges)-1);
subplot_num = [1:2:length(stims),2:2:length(stims)];
ymax = 0;

figure()
for i = 1:length(stims)
    dir_onset = find(directions == stims(i));
    psth = PSTH(spikeTimes,stimOnsets(dir_onset),stimDuration,edges,preStim,postStim);
    ax(i) = subplot(length(stims)/2,2,subplot_num(i));
    bar(centers/1000,psth/length(dir_onset)*1000/bin_width,1)
    title([num2str(stims(i)),'°'])
    if max(psth/length(dir_onset)*1000/bin_width)>ymax
        ymax = max(psth/length(dir_onset)*1000/bin_width);
    end
    if i == 4
        ylabel('firing rate [spikes/s]')
    end
end
linkaxes(ax);
xlim([-preStim,stimDuration+postStim]/1000)
ylim([0,ymax])
set(ax([1:length(stims)/2-1,length(stims)/2+1:length(stims)-1]),'xticklabel',[])
xlabel(ax(length(stims)/2),'t [s]')
xlabel(ax(length(stims)),'t [s]')



