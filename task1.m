% prepare data
clear all
close all
set(0,'DefaultFigureWindowStyle','docked')
load NDA_rawdata
x  = gain * double(x);

%% run code
y = filterSignal(x,samplingRate);
[s, t] = detectSpikes(y,samplingRate);
%w = extractWaveforms(y,s);
%b = extractFeatures(w);

%% plot figures
tmin = 277;%183.6;
tmax = 278;%183.9;
time = 0:1/samplingRate:(length(x)-1)/samplingRate;

%shorten the vectors to the window fo faster plotting
tmin_idx = round(tmin*samplingRate);
tmax_idx = round(tmax*samplingRate);
time_lim = time(tmin_idx:tmax_idx);
y_lim = y(tmin_idx:tmax_idx,:);
t_lim = t((t>tmin) & t<(tmax));
s_lim = s((s>tmin_idx) & (s<tmax_idx));

N = 4;
sigma = median(abs(y)/0.6745);
thresh = N*sigma;

figure(1)
for i = 0:3
    ax(i*2+1) = subplot(4,2,i*2+1);
    hold on
    plot(time*1000,x(tmin*samplingRate:tmax*samplingRate,i+1),'b')
    %ax((i+1)*2) = subplot(4,2,(i+1)*2);
    plot(time*1000,y(tmin*samplingRate:tmax*samplingRate,i+1),'r')
    hold off
end
linkaxes(ax,'x') 

figure(2)
for i = 1:4
    ax(i) = subplot(4,1,i);
    hold on
    plot(time_lim,y_lim(:,i),'k')
    plot(t_lim,y(s_lim,i),'ro')
    plot([tmin,tmax],[-thresh(i),-thresh(i)],'r')
    hold off
    xlim([tmin,tmax])
end
linkaxes(ax,'x') 