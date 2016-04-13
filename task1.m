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
    hold on
    plot(time_lim,x_lim(:,i+1))
    ax1((i+1)*2) = subplot(4,2,(i+1)*2);
    plot(time_lim,y_lim(:,i+1))
    hold off
end
linkaxes(ax1,'x') 

figure(2)
for i = 1:4
    ax2(i) = subplot(4,1,i);
    hold on
    plot(time_lim,y_lim(:,i),'k')
    plot(t_lim,y(s_lim,i),'ro')
    plot([tmin,tmax],[-thresh(i),-thresh(i)],'r')
    hold off
    xlim(ax2(i),[tmin,tmax])
end
linkaxes(ax2,'x') 

figure(3)
[m mi] = sort(w);
[l li]= sort(m,2);
lowest100index = li(1,1:100,:);
lowest100w = zeros(30,100,4);
for i = 1:4
  lowest100w(:,:,i) = w(:,lowest100index(1,:,i),i);
end

 for i = 1:4
   subplot(4,2,i);
   for j = 1:100
     plot(1:length(w(:,1,1)),w(:,j,i), 'color','b');
     axis tight;
     title(['Hundred first spikes channel',' ',num2str(i)])
     hold on
   end
   hold off
   subplot(4,2,i+1)
   for k = 1:100
     plot(1:length(w(:,1,1)), lowest100w(:,k,i),'color','b');
     axis tight;
     title(['Hundred maximal spikes channel',' ',num2str(i)])
     hold on
   end
 end
 x_ms = (((1:30)-1)/samplingRate)*1000;
 for i = 0:3
    ax(i*2+1) = subplot(4,2,i*2+1);
    for j = 1:100
     plot(x_ms,w(:,j,i+1), 'color','b');
     axis tight;
     xlabel('[ms]');
     ylabel('[mV]');
     title(['first hundred spikes of channel',' ',num2str(i+1)])
     hold on
    end   
    ax((i+1)*2) = subplot(4,2,(i+1)*2);
    for k = 1:100
     plot(x_ms, lowest100w(:,k,i+1),'color','b');
     axis tight;
     title(['Hundred maximal spikes of channel',' ',num2str(i+1)])
     xlabel('[ms]');
     ylabel('[mV]');
     hold on
    end    
 end
 
figure(4)
x_vec = [1 1 1 4 4 7];
y_vec = [4 7 11 7 11 11];
for i = 1:6
    ax4(i) = subplot(3,2,i);
    plot(b(:,x_vec(i)),b(:,y_vec(i)),'.')
%     xlabel('1_{st}PC of channel X')
%     ylabel('1_{st}PC of channel Y')
end
linkaxes(ax4)
%ylim([-100,100])
%xlim([-100,100])

 