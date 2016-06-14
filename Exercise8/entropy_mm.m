function H = entropy_mm(p)
% function H = entropy_mle(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy with miller-maddow correction

Hn = entropy_mle(p);
H = Hn + (length(p)-1)/(2*sum(p));