function [min_amp, surr_idx] = peak_amp(g_trace)
%gives the index of the minimum amplitude
%g_trace: trace of which the minimum amplitude is calculated
%min_amp: value of minimum amplitude
%surr_idx: indizes of start and end of peak

[max_v, max_idx] = findpeaks(g_trace);
[min_val, min_idx] = findpeaks(-g_trace);
min_v = -min_val;
max_amp = max_idx*0;
surr_idx = zeros(length(max_idx),2);

for i = 1:length(max_idx)
    [~,m_idx] = min(abs(max_idx(i)-min_idx));
    if min_idx(m_idx) < max_idx(i)
        idx1 = m_idx;
        idx2 = m_idx+1;
    elseif min_idx(m_idx) >= max_idx(i)
        idx1 = m_idx-1;
        idx2 = m_idx;
    end
    if idx1 < 1 | idx2 > length(min_idx)
        surr_idx(i,:) = [nan,nan];
        max_amp(i) = inf;
    else
        surr_idx(i,:) = min_idx([idx1, idx2]);
        max_amp(i) = g_trace(max_idx(i)) - mean(g_trace(min_idx([idx1, idx2])));
    end 
end
[min_amp, m_idx] = min(max_amp);
surr_idx = surr_idx(m_idx,:);