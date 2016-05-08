clear all
close all
set(0,'DefaultFigureWindowStyle','docked')

load('TrainingData.mat')

%% Parameters for fitting
Ca_0 = 0:0.1:1;
A
stren = 0.02:0.01:0.13;
q = 0.2;%0.1:0.02:0.3;
fac = 1:6;
corr_vec = zeros(length(tau),length(stren),length(fac),length(data));
m_s_er = zeros(length(tau),length(stren),length(fac),length(data));

%% fitting the data
for k = 1:length(data)
    disp(k)
    trace = data(k);
    s_trace = trace.SpikeTraces;
    g_trace = double(trace.GalvoTraces);
    fps = trace.fps;
    dt = 1/fps;
    for l = 1:length(fac)
        for i = 1:length(tau)
            for j = 1:length(stren)
                [Ca] = Ca_func(s_trace, g_trace(1), quantile(g_trace,q), tau(i), dt, stren(j),fac(l));
                corr_vec(i,j,k) = corr(Ca,g_trace);
                m_s_er(i,j,k) = immse(Ca,g_trace);
            end
        end
    end
end

%% get best Parameters...
% ... according to the correlation
corr_vec2 = mean(corr_vec,4);
[m,i] = max(corr_vec2,[],1);
[m2,i2] = max(m);
[m3,i3] = max(m2);

max_tau = tau(i(i2(i3)));
max_stren = stren(i2(i3));
max_fac = fac(i3);
max_corr = corr_vec2(i(i2(i3)),i2(i3),i3);
disp(['tau=',num2str(max_tau),', stren=',num2str(max_stren), ', fac=', num2str(max_fac), ', corr=', num2str(max_corr)])

% ... according to mean square
m_s_er2 = mean(m_s_er,4);
[m,i] = min(m_s_er2,[],1);
[m2,i2] = min(m);
[m3,i3] = min(m2);

min_tau = tau(i(i2(i3)));
min_stren = stren(i2(i3));
min_fac = fac(i3);
min_corr = corr_vec2(i(i2(i3)),i2(i3),i3);
disp(['tau=',num2str(min_tau),', stren=',num2str(min_stren), ', fac=', num2str(min_fac), ', sqerr=', num2str(min_corr)])

% % result of fit
% 
% min_tau = 0.85;
% min_stren = 0.12;
% min_fac = 3;
% max_tau = 0.6;
% max_stren = 0.03;
% max_fac = 5;

m_tau = mean([min_tau, max_tau]);
m_stren = mean([min_stren, max_stren]);
m_fac = mean([min_fac, max_fac]);

%% plotting the data
new_corr = zeros(length(data),1);
new_sqerr = zeros(length(data),1);
for i = 1:length(data)
    trace = data(i);
    s_trace = trace.SpikeTraces;
    g_trace = double(trace.GalvoTraces);
    fps = trace.fps;
    dt = 1/fps;    
    qplot = quantile(g_trace,q);
    
    [Ca_max] = Ca_func(s_trace, g_trace(i), quantile(g_trace,q), max_tau, dt, max_stren, max_fac);
    [Ca_min] = Ca_func(s_trace, g_trace(i), quantile(g_trace,q), min_tau, dt, min_stren, min_fac);
    [Ca_mean] = Ca_func(s_trace, g_trace(i), quantile(g_trace,q), m_tau, dt, m_stren, m_fac);
    
    figure()
    ax(1) = subplot(311);
    title('fit with mean square error')
    %plot(s_trace)
    hold on
    plot(g_trace,'b')
    plot(Ca_min,'r')
    plot([1,length(Ca_min)],[qplot,qplot],'g')
    hold off
    ax(2) = subplot(312);
    title('fit with correlation')
    hold on
    plot(g_trace,'b')
    plot(Ca_max,'r')
    plot([1,length(Ca_max)],[qplot,qplot],'g')
    hold off
    ax(3) = subplot(313);
    title('mean of parameters of both')
    hold on
    plot(g_trace,'b')
    plot(Ca_mean,'r')
    plot([1,length(Ca_mean)],[qplot,qplot],'g')
    hold off
    
    linkaxes(ax,'x')
    new_corr(i) = corr(Ca_min,g_trace);
    new_sqerr(i) = immse(Ca_max,g_trace);
end
new_corr'
new_sqerr'