function [f df] = logLikLnp(x,c,s,sa)

% [f df] = logLikLnp(x,c,s)
%   Implements the negative (!) log-likelihood of the LNP model and its
%   gradient with respect to the receptive field w.
%
%   x   current receptive field (225 x 1)
%   c   spike counts (1 x T/dt)
%   s   stimulus matrix (225 x T/dt)
%
%   f   function value of the negative log likelihood at x (scalar)
%   df  gradient of the negative log likelihood with respect to x (225 x 1)
%
% PHB 2012-06-25

r = sum(sa'*exp(x*s),1);
f =  - sum(c.*log(r) - logfac(c) - r);
df = - sum(repmat(s*c',[1,numel(c)]) - s.*repmat(r,[size(s,1),1]),2);


