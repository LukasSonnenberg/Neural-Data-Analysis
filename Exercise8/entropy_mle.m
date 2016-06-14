function H = entropy_mle(p)
% function H = entropy_mle(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy

n = sum(p); % total number of samples
H = log(n) - nansum(p.*log(p))/n;