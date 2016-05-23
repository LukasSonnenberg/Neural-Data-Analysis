function [ind] = linearityIndex(spikeTimes, stimOnsets, stimDuration,kernelWidth)

% spikeTimes is a (n,1) array of spikes 
%  stimOnsets is stimulus onsets *only* for the direction of interest
% stimDuration is scalar, stim duration
% kernelWidth is scalar, width of kernel to create the PSTHgit 


% we know in advance that the frequency is 3.4Hz
stims = stimOnsets;
spikes = zeros(stimDuration+1,length(stims));
for n1 = 1:length(stims)
   tspikes = spikeTimes(spikeTimes>stims(n1) & spikeTimes < (stims(n1)+stimDuration))-stims(n1);
   spikes(round(tspikes)+1,n1) = spikes(round(tspikes)+1,n1)+1;
end
spikes = sum(spikes,2);
   
% convolve with constant kernel of optimal width?
ker = ones(1,kernelWidth);
spikes = conv(spikes,ker,'same');

% since times are in ms the effective sampling frequency is 1000Hz
f = 2*pi*3.4/1000;

t = 0:stimDuration; % convenient hack because stimDuration is in milliseconds already...
F = exp(-i*t*f);
ind = F*spikes;
phase = tan(imag(ind)/real(ind));
% using phase from DTFT
figure;
plot(t,0.5*max(spikes)*sin(f*t'+(phase*1000/2/pi)));
hold on;
plot(t,spikes);
%text(1000,max(spikes)+0.5*std(spikes),sprintf('Linearity Index: %.2e',abs(ind)));
title(sprintf('Linearity Index: %.2e',abs(ind)))
xlabel('t [ms]')