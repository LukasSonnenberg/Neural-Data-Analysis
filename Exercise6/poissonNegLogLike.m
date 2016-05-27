function [logLike, gradient] = poissonNegLogLike(p, counts, theta)
% Negative log likelihood for Poisson spike count and von Mises tuning.
%   [logLike, gradient] = poissonNegLogLike(p, counts, theta) returns the
%   log-likelihood (and its gradient) of the von Mises model with Poisson
%   spike counts.
%
%   Inputs:
%       p           four-element vector of tuning parameters
%       counts      column vector of spike counts
%       theta       column vector of directions of motion (same size as
%                   spike counts)
%
%   Outputs:
%       logLike     negative log-likelihood
%       gradient    gradient of negative log-likelihood with respect to 
%                   tuning parameters (four-element column vector)

% so Poisson additive noise, while I suppose ideal, doesn't differentiate
% by hand, which means I guess we assume that our values have distribution
% Poission(f(\theta)) 

%%%% IMPORTANT NOTE: I'm omitting terms constant in the argument

% since we need counts - g(\theta)*exp(g(\theta)) for all the derivatives,
% pre-calculate it:

expdiff = counts - arrayfun(@(t) g(t,p),theta);
gradient = zeros(4,1);

gradient(1) = -sum(expdiff); % derivative w.r.t alpha is 1
gradient(4) = -sum(expdiff .* arrayfun(@(t) dchi(t,p),theta));
gradient(2) = -sum(expdiff .* arrayfun(@(t) dkappa(t,p),theta));
gradient(3) = -sum(expdiff .* arrayfun(@(t) deta(t,p),theta));

logLike = -sum(counts .* arrayfun(@(t) g(t,p),theta) - arrayfun(@(t) exp(g(t,p)),theta));
end


% convenience-ish function for the inside of the exponential of the von M
% function
function out  = g(theta, params)
    out = params(1) + params(2)*(cosd(2*(theta-params(4)))-1) + params(3)*(cosd(theta-params(4))-1);
end

function out = dkappa(theta, params)
    out = cosd(2*(theta - params(4)))-1;
end

function out = deta(theta, params)
    out = cosd(theta - params(4)) - 1;
end

function out = dchi(theta,params)
    out = 2 * params(2) * sind(2*(theta - params(4))) + params(3) * sind(theta - params(4));
end