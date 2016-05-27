function [p, q, qdistr] = testTuning(dirs, counts)
% Test significance of orientation tuning by permutation test.
%   [p, q, qdistr] = testTuning(dirs, counts) computes a p-value for
%   orientation tuning by running a permutation test on the second Fourier
%   component.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)
%
%   Outputs:
%       p           p-value
%       q           magnitude of second Fourier component
%       qdistr      sampling distribution of |q| under the null hypothesis
nits = 1000;
qdistr = zeros(nits,1);
[~, q] = fitCos(dirs, counts);
for i = 1:nits
   vcounts = reshape(counts, 1, []);
   ind = randperm(length(vcounts)); 
   permcount = reshape(vcounts(ind),size(counts,1),size(counts,2));
   [~,qdistr(i)] = fitCos(dirs, permcount);
end

% p-value is the % of entries that have a higher or equal q 
p = mean(qdistr >= q);
