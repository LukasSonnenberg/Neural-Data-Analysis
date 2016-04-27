function plotWaveforms(w, assignments, varargin)
% Plot waveforms for each cluster.
%   plotWaveforms(w, assignment) plots for all four channels of each
%   cluster 100 sample waveforms, overlaid by the average waveform. All
%   panels are drawn on the same scale to facilitate comparison.

colors = [0 0 0; 0 0 1; 0 1 0; 1 0 0; 0 1 1; 1 0 1; 1 1 0; .5 .5 .5; 0 0 .5];
C = max(assignments);
figure()
for c = 1:C
    w1 = w(:,assignments == c,:);
    if size(w1,2)<100
        spikes = size(w1,2);
    else
        spikes = 100;
    end
    for i = 1:4
        ax(c+(i-1)*C) = subplot(4,C,c+(i-1)*C);
        hold on
        for j = 1:spikes
            plot(w1(:,j,i),'color',colors(c,:))
        end
        hold off
        xlim([1,30])
    end
end
        
set(ax,'XTickLabel',[],'YTickLabel',[])
