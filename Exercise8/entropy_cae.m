function H = entropy_cae(p)

% function H = entropy_cae(p)
%   p   vector with observed frequencies of all words
%   H   coverage adjusted estimate of entropy

n=sum(p);
% estimate coverage first
C_hat = 1 - length(find(p==1))/n;
p_hat = p/n;
p_tilde = C_hat*p_hat;

H = -nansum((p_tilde.*log2(p_tilde))./(1-(1-p_tilde).^n));