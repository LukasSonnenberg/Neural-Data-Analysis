function plotOptimalPsth(spikeTimes, stimOnsets, directions, stimDuration)

preStim = 500;
postStim = 500;
bin_width = 20;
edges = -preStim:bin_width:stimDuration+postStim;

stims = unique(directions);
cost = cell(1,numel(spikeTimes));
psth = cell(1,numel(spikeTimes));
maxidx = zeros(1,length(psth));
maxval = zeros(1,length(psth));

for i = 1 : numel(spikeTimes)
    sTimes = spikeTimes{i};
    spikesum = zeros(1,length(stims));
    for j = 1:length(stims)
        onset = stimOnsets(find(directions == stims(j)));
        for k = 1:length(onset)
            spikesum(j) = spikesum(j) + sum(sTimes(sTimes>onset(k)-preStim & sTimes<onset(k)+stimDuration+postStim));
        end
    end
    [maxval(i), maxidx(i)] = max(spikesum);
    dir_onset = find(directions == stims(maxidx(i)));
    [cost{i},width,psth{i}] = CostFun(sTimes,stimOnsets(dir_onset),stimDuration,preStim,postStim);
    %cost{i} = conv(cost{i},ones(1,7)/7,'same');
    [~,idx] = min(cost{i}(width(width<100)));
    subplot(1,4,i)
    hold on
    plot(width/1000,cost{i},'k.','MarkerFaceColor','k')
    plot(width(idx)/1000,cost{i}(idx),'ro','MarkerFaceColor','r')
    hold off
end

figure()
for i = 1 : numel(spikeTimes)
    sTimes = spikeTimes{i};
    dir_onset = find(directions == stims(maxidx(i)));
    [~,idx] = min(cost{i}(width(width<100)));
    good_width = width(idx);
    low_width = floor(good_width/3);
    high_width = ceil(good_width*3);
    
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
    xlim([-preStim,stimDuration + postStim]/1000)
    title(['cell',num2str(i),', \Delta = ',num2str(high_width), ' (too large)'])
    
end
