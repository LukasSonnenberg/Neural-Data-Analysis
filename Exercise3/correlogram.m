function [ccg, bins] = correlogram(t, assignments, binsize, maxlag)
% Calculate cross-correlograms.
%   ccg = calcCCG(t, assignment, binsize, maxlag) calculates the cross- and
%   autocorrelograms for all pairs of clusters with input
%       t               spike times             #spikes x 1
%       assignment      cluster assignments     #spikes x 1
%       binsize         bin size in ccg         scalar
%       maxlag          maximal lag             scalar
% 
%  and output
%       ccg             computed correlograms   #bins x #clusters x
%                                                               #clusters
%       bins            bin times relative to center    #bins x 1

C = max(assignments); % # of clusters

%bins = -maxlag-binsize/2:binsize:maxlag+binsize/2; % bin times with 0 as
                                                    % between two bins
bins = -maxlag:binsize:maxlag;                      % bin times with 0 as 
                                                    % center of a bin
edges = bins(1)-binsize/2:binsize:bins(end)+binsize/2; % edges of bins
ccg = zeros(length(bins),C,C);

for c1 = 1:C
    t1 = t(assignments == c1);
    for c2 = 1:C
        t2 = t(assignments == c2);
        %c_corr = zeros(length(t1));
        c_corr = [];
        for i = 1:length(t1)
            c_corr = [c_corr;t1(i)-t2(t2>t1(i)+edges(1) & t2<t1(i)+edges(end) & t2 ~= t1(i))];
        end
        ccg(:,c1,c2) = histcounts(c_corr,edges);
    end
end
