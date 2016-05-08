function [g_trace] = LocAv(g_trace,thresh,max_iterations)
%takes the smallest amplitudes and averages them with their neigbours to
%get rid of them
%runs until the smallest amplitude is over a threshold or the maximum of
%allowed iterations is reached

%g_trace: this trace will be smoothed
%thresh: amplitudes below this threshold will be averaged, recommended: 0.1
%max_iterations: maximum number of averaging steps, recommended: 2k-4k

[min_amp, surr_idx] = peak_amp(g_trace);
i = 1;
while min_amp<thresh && i<max_iterations
    i = i+1;
    idx1 = surr_idx(1);
    idx2 = surr_idx(2);
    g_trace(idx1:idx2) = conv(g_trace(idx1-1:idx2+1), [1 1 1]/3,'valid');
    [min_amp, surr_idx] = peak_amp(g_trace);
end
