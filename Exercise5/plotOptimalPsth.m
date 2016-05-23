function [KernelWidth,onset_cell] = plotOptimalPsth(spikeTimes, stimOnsets, directions, stimDuration)
% plot a PSTH with optimal bin width
% spikeTimes: times of all spikes independent of stimulus
% stimOnsets: times of onsets of all stimuli
% directions: orientation of each given stimulus
% stimDuration: lengt of stimulus in ms

preStim = 500;
postStim = 500;
bin_width = 20;
edges = -preStim:bin_width:stimDuration+postStim;

% prepare empty cells/arrays and an array of possible stimuli
stims = unique(directions); %possible stimuli
cost = cell(1,numel(spikeTimes)); %cost function for each recorded neuron
psth = cell(1,numel(spikeTimes)); 
maxidx = zeros(1,length(psth)); %index to find best orientation, at which the neuron responds best
maxval = zeros(1,length(psth)); %number of spikes for this best orientation

%% get the cost functions for different bin widths and plot them
figure()
for i = 1 : numel(spikeTimes)
    %find orientation of cell at which it responds best
    sTimes = spikeTimes{i};
    spikesum = zeros(1,length(stims));
    for j = 1:length(stims)
        onset = stimOnsets(find(directions == stims(j)));
        for k = 1:length(onset)
            spikesum(j) = spikesum(j) + sum(sTimes(sTimes>onset(k) & sTimes<onset(k)+stimDuration));
        end
    end
    [maxval(i), maxidx(i)] = max(spikesum);
    dir_onset = find(directions == stims(maxidx(i)));
    
    %cost function dependent on bin width
    [cost{i},width,psth{i}] = CostFun(sTimes,stimOnsets(dir_onset),stimDuration,preStim,postStim);
    %index of minimum of cost function
    [~,idx] = min(cost{i}(width(width<100)));
    
    %plot cost function
    subplot(1,4,i)
    hold on
    plot(width/1000,cost{i},'k.','MarkerFaceColor','k')
    plot(width(idx)/1000,cost{i}(idx),'ro','MarkerFaceColor','r')
    xlabel('kernel width [s]')
    if i == 1
        ylabel('cost')
    end
    hold off
end

%% plot optimal bin widths together with too small and too wide widths
figure()
KernelWidth = zeros(1,4);
onset_cell = cell(1,4);
for i = 1 : numel(spikeTimes)
    sTimes = spikeTimes{i};
    dir_onset = find(directions == stims(maxidx(i)));
    [~,idx] = min(cost{i}(width(width<100)));
    good_width = width(idx);
    low_width = floor(good_width/3);
    high_width = ceil(good_width*3);
    KernelWidth(i) = good_width;
    onset_cell{i} = dir_onset;
    
    good_edges = -preStim:good_width:stimDuration+postStim;
    low_edges = -preStim:low_width:stimDuration+postStim;
    high_edges = -preStim:high_width:stimDuration+postStim;
 
    good_centers = linspace(mean(good_edges(1:2)),mean(good_edges(end-1:end)),length(good_edges)-1);
    low_centers = linspace(mean(low_edges(1:2)),mean(low_edges(end-1:end)),length(low_edges)-1);
    high_centers = linspace(mean(high_edges(1:2)),mean(high_edges(end-1:end)),length(high_edges)-1);
    
    good_psth = PSTH(sTimes,stimOnsets(dir_onset),stimDuration,good_edges,preStim,postStim);
    low_psth = PSTH(sTimes,stimOnsets(dir_onset),stimDuration,low_edges,preStim,postStim);
    high_psth = PSTH(sTimes,stimOnsets(dir_onset),stimDuration,high_edges,preStim,postStim);
 
    ax(i) = subplot(3,4,i);
    bar(low_centers/1000,low_psth/length(dir_onset)*1000/low_width,1)
    xlim([-preStim,stimDuration + postStim]/1000)
    title(['cell',num2str(i),', \Delta = ',num2str(low_width), ' (too small)'])
    
    ax(i+4) = subplot(3,4,i+4);
    bar(good_centers/1000,good_psth/length(dir_onset)*1000/good_width,1)
    xlim([-preStim,stimDuration + postStim]/1000)
    title(['cell',num2str(i),', \Delta = ',num2str(good_width), ' (optimal)'])
    
    ax(i+8) = subplot(3,4,i+8);
    bar(high_centers/1000,high_psth/length(dir_onset)*1000/high_width,1)
    xlabel('t [s]')
    xlim([-preStim,stimDuration + postStim]/1000)
    title(['cell',num2str(i),', \Delta = ',num2str(high_width), ' (too large)'])
end
 saveas(gcf, 'Ex3', 'pdf')
