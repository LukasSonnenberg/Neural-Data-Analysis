function params = fitML(dirs, counts)
% Fit tuning curve using maximum likelihood and Poisson noise model.
%   params = fitML(dirs, counts) fits a parametric tuning curve using
%   maximum liklihood and a Poisson noise model and returns the fitted
%   parameters.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)


%set several starting values
p0 = [...
        15 4 0 180;...
        17 0.2 0.3 150;... 
        16 20.8 -0.58 80; ...
        ];
    
P = zeros(4,size(p0,1),size(counts,1));
fx = zeros(size(p0,1),size(counts,1));
for j = 1:size(counts,1)
for i = 1:size(p0,1)
    [P(:,i,j), fx(i,j)] = minimize(p0(i,:)', @(p)(poissonNegLogLike(p,counts(j,:)',dirs)),1000);
end
end
[~,ind] = min(fx(:));
params = P(:,ind);