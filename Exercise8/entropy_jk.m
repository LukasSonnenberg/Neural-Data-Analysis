function H = entropy_jk(p)
% function H = entropy_jk(p)
%   p   vector with observed frequencies of all words
%   H   jackknife estimate of entropy

% jack-knifed entropy estimator (paninski, p. 1198)

n = sum(p);
Hi_sum = n*log2(n-1) - (nansum((n-p).*(p.*log2(p))) + nansum(p.*((p-1).*log2(p-1))))/(n-1);
H_i = Hi_sum/n;
H = entropy_mle(p)*n - (n-1)*H_i;