function w = extractWaveforms(x, s)
% Extract spike waveforms.
%   w = extractWaveforms(x, s) extracts the waveforms at times s (given in
%   samples) from the filtered signal x using a fixed window around the
%   times of the spikes. The return value w is a 3d array of size
%   length(window) x #spikes x #channels.
%% define interval around local minimum build average
time_window = 0.001;
% window_size determines amount of data points
samplingRate = 30000;
window_size = samplingRate*time_window;
% preallocation of w
w = zeros(window_size,length(s), length(x(1,:)));
% rel_pos_min determines the position of the spike within the window
rel_pos_min = 0.3;
low_limit = round(window_size*rel_pos_min);
up_limit = window_size-low_limit;
s = s((s>low_limit) & (s<(length(x)-up_limit))); %remove spikes that exceed the time window

for i = 1: length(x(1,:))
  for j = 1: length(s)
      w(:,j,i) =(x((s(j)+1- low_limit):(s(j)+up_limit),i));
  end
end