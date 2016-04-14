function [s, t] = detectSpikes(x, Fs)
% Detect spikes.
%   [s, t] = detectSpikes(x, Fs) detects spikes in x, where Fs the sampling
%   rate (in Hz). The outputs s and t are column vectors of spike times in
%   samples and ms, respectively. By convention the time of the zeroth
%   sample is 0 ms.

%get threshold
N = 4;
sigma = median(abs(x)/0.6745);
thresh = N*sigma;

%get start and end of passover of threshold
passover = diff(bsxfun(@lt,x,-thresh));
pass_start=cell(4,1);
pass_end = cell(4,1);
for i = 1:4
    pass_start{i} = find(passover(:,i) == 1);
    pass_end{i} = find(passover(:,i) == -1);
    if i == 1 %if array starts with spike delete this one
        if pass_start{i}(1)>pass_end{i}(1)
            pass_end{i} = pass_end{i}(2:end);
        end
    end
end

%get time points if minima of passovers
minima = cell(4,1);
for i = 1:4
    minima{i} = zeros(length(pass_start{i}),1);
    for j = 1:length(pass_start{i})
        [val,idx] = min(x(pass_start{i}(j):pass_end{i}(j),i));
        minima{i}(j) = pass_start{i}(j)-1+idx;
    end
end

%compare the four channels and assume that almost near spikes are the same
%spike
same_spike = 3;
other_spike = 8;
spikes = sort([minima{1}; minima{2}; minima{3}; minima{4}]);
near_spikes = [0; diff(spikes)<same_spike]; %the minima of spikes are allowed to differ by 2 timesteps to be counted as one spike
all_spikes = spikes(near_spikes==0);
%throw away spikes, that are too close to each other (two different spikes
%at same time)
double_spikes = [(diff(all_spikes)>same_spike) & (diff(all_spikes)<other_spike); 0];
s = spikes(double_spikes==0);
t=(s-1)/Fs;
