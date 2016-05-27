function y = tuningCurve(p, theta)
% Evaluate tuning curve.
%   y = tuningCurve(p, theta) evaluates the parametric tuning curve at
%   directions theta (in degrees, 0..360). The parameters are specified by
%   a 1-by-k vector p.
y = exp(p(1) + p(2)*(cosd(2*(theta - p(4)))-1) + p(3)*(cosd(theta-p(4))-1));