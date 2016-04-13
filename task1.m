% plot figures
% prepare data
clear all
close all
load NDA_rawdata
x  = gain * double(x);

%% run code
y = filterSignal(x,samplingRate);
[s, t] = detectSpikes(y,samplingRate);
w = extractWaveforms(y,s);
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

 
[m mi] = sort(w);
[l li]= sort(m,2);
lowest100index = li(1,1:100,:);
lowest100w = zeros(30,100,4);
for i = 1:4
  lowest100w(:,:,i) = w(:,lowest100index(1,:,i),i);
end


figure(3)
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