% prepare data
clear all
close all
load NDA_rawdata
x  = gain * double(x);

%% run code
y = filterSignal(x,samplingRate);
% [s, t] = detectSpikes(y,samplingRate);
%w = extractWaveforms(y,s);
%b = extractFeatures(w);

%% plot figures
tmin = 183.6;
tmax = 183.9;
time = 0:1/samplingRate:tmax-tmin;
figure(1)
for i = 0:3
    ax(i*2+1) = subplot(4,2,i*2+1);
    plot(time*1000,x(tmin*samplingRate:tmax*samplingRate,i+1))
    ax((i+1)*2) = subplot(4,2,(i+1)*2);
    plot(time*1000,y(tmin*samplingRate:tmax*samplingRate,i+1))
end
 linkaxes(ax,'x') 

figure(2)
