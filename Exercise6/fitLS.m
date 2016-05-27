function params = fitLS(dirs, counts)
% Fit parametric tuning curve using least squares.
%   params = fitLS(dirs, counts) fits a parametric tuning curve using least
%   squares and returns the fitted parameters. 
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)

fun = @(p,theta)exp(p(1) + p(2)*(cosd(2*(theta - p(4)))-1) + p(3)*(cosd(theta-p(4))-1));
lb = [-400,-40,-40,0];
ub = [400,40,40,360];

%set several starting values
p0 = [...
        15 4 0 180;...
        17 0.2 0.3 150;... 
        16 20.8 -0.58 80; ...
        ];
    
sqerr = zeros(size(p0,1),1);
params = zeros(size(p0,1),4);

% fit median with mean square
for i = 1:size(p0,1)
    [params(i,:),sqerr(i)] = lsqcurvefit(fun,p0(i,:),dirs,median(counts,1)',lb,ub);
end
[~,minidx] = min(sqerr);
params = params(minidx,:);
