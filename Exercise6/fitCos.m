function f = fitCos(dirs, counts)
% Fit cosine tuning curve.
%   f = fitCos(dirs, counts) fits a cosine tuning curve by projecting on
%   the second Fourier component. Returns f, a vector of estimated spike
%   counts given the cosine tuning curve.
%
%   Inputs:
%       counts  matrix of spike counts as returned by getSpikeCounts.
%       dirs    vector of directions (#directions x 1)

m = mean(counts,1);
v = 1/4*exp(2i*dirs/360*2*pi);
q = m*v;
f = mean(m) + conj(q).*v + q.*conj(v);
