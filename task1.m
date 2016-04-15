% prepare data
clear all
close all
set(0,'DefaultFigureWindowStyle','docked')
load NDA_rawdata
x  = gain * double(x);
%x = x(1:length(x)/10);
%% run code
y = filterSignal(x,samplingRate);
[s, t] = detectSpikes(y,samplingRate);
w = extractWaveforms(y,s);
b = extractFeatures(w);


%% plot figures
tmin = 277;%183.6;
tmax = 278;%183.9;
time = 0:1/samplingRate:(length(x)-1)/samplingRate;

%shorten the vectors to the window fo faster plotting
tmin_idx = round(tmin*samplingRate);
tmax_idx = round(tmax*samplingRate);
time_lim = time(tmin_idx:tmax_idx);
x_lim = x(tmin_idx:tmax_idx,:);
y_lim = y(tmin_idx:tmax_idx,:);
t_lim = t((t>tmin) & t<(tmax));
s_lim = s((s>tmin_idx) & (s<tmax_idx));

N = 4;
sigma = median(abs(y)/0.6745);
thresh = N*sigma;

figure(1)
for i = 0:3
    ax1(i*2+1) = subplot(4,2,i*2+1);
    plot(time_lim,x_lim(:,i+1),'k')
    xlabel('t [s]')
    ylabel('V [mV]')
    
    ax1((i+1)*2) = subplot(4,2,(i+1)*2);
    plot(time_lim,y_lim(:,i+1),'k')
    xlabel('t [s]')
    ylabel('V [mV]')
end
linkaxes(ax1,'x') 

figure(2)
for i = 1:4
    ax2(i) = subplot(4,1,i);
    hold on
    plot(time_lim,y_lim(:,i),'k')
    plot(t_lim,y(s_lim,i),'ro')
    plot([tmin,tmax],[-thresh(i),-thresh(i)],'r')
    xlabel('t [s]')
    ylabel('V [mV]')
    hold off
    xlim(ax2(i),[tmin,tmax])
end
linkaxes(ax2,'x') 

figure(3)
[l, li] = sort(min(min(w(1:15,:,:),[],1),[],3));
lowest100w = w(:,li(1:100),:);

 x_ms = (((1:30)-1)/samplingRate)*1000;
 for i = 0:3
    ax3(i*2+1) = subplot(4,2,i*2+1);
    for j = 1:100
     plot(x_ms,w(:,j,i+1), 'color','b');
     axis tight;
     xlabel('t [ms]');
     ylabel('V [mV]');
%      title(['first hundred spikes of channel',' ',num2str(i+1)])
     title(['channel ',num2str(i+1), ', first hundred spikes'])
     hold on
    end
    hold off
    ax3((i+1)*2) = subplot(4,2,(i+1)*2);
    for k = 1:100
     plot(x_ms, lowest100w(:,k,i+1),'color','b');
     axis tight;
%      title(['Hundred maximal spikes of channel',' ',num2str(i+1)])
     title(['channel',' ',num2str(i+1), ', hundred largest spikes'])
     xlabel('t [ms]');
     ylabel('V [mV]');
     hold on
    end    
    hold off
 end

 
figure(4)
first_pc = b(:,[1 4 7 11]);
x_vec = [1 1 1 2 2 3];
y_vec = [2 3 4 3 4 4];
for i = 1:6
    ax4(i) = subplot(3,2,i);
    plot(first_pc(:,x_vec(i)),first_pc(:,y_vec(i)),'.')
    xlabel(['1_{st}PC of channel ',num2str(x_vec(i))])
    ylabel(['1_{st}PC of channel ',num2str(y_vec(i))])
end
linkaxes(ax4)
ylim([-200,200])
xlim([-200,200])
 