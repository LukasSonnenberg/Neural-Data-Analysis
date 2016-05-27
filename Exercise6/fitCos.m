function f, mag = fitCos(dirs, counts)
% Fit cosine tuning curve.
%   f = fitCos(dirs, counts) fits a cosine tuning curve by projecting on
%   the second Fourier component. Returns f, a vector of estimated spike
%   counts given the cosine tuning curve.
%
%   Inputs:
%       counts  matrix of spike counts as returned by getSpikeCounts.
%       dirs    vector of directions (#directions x 1)
%   Outputs:
%       f       vector of estimated spike counts
%       mag     magnitude of second Fourier component