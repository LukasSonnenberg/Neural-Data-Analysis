function H = entropy_jk(p)
% function H = entropy_jk(p)
%   p   vector with observed frequencies of all words
%   H   jackknife estimate of entropy

% jack-knifed entropy estimator (paninski, p. 1198)

% find used categories
K = length(find(p));
n = sum(p);
Hi_sum = n*log(n-1) - nansum((K-p).*(p.*log(p)) + p.*((p-1).*log(p-1)))/(n-1);
H_i = Hi_sum/n;
H = entropy_mle(p)*n - (n-1)*H_i;