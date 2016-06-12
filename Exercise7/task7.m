clear all
close all
set(0,'DefaultFigureWindowStyle','docked')
%% Task 7.1: fit instantaneous receptive field

% parameter settings
par.T = 200000;                     % duration of experiment in ms
par.dt = 20;                        % bin width in ms
par.gabor = [0.2 0.05 .3 pi/2];     % settings for spatial rf (gabor)
par.temp = [NaN NaN NaN 1];         % settings for temporal kernel (raised cosine)
par.stimtype = 'gaussian';
par.nonlin = 'exp';

% get spike counts
[c s w_true] = sampleLnp(par);
%w_true = reshape(w_true,[15,15]);

% fit receptive field
w_est = fitRf(c,s,1);

% visualize true and estimated receptive field (on same scale)

% ADD YOUR CODE HERE ....
clim = [min([w_true; w_est]), max([w_true; w_est])];

figure();
subplot(211)
imagesc(reshape(w_true,[15 15]),clim)
%axis equal
subplot(212)
imagesc(reshape(w_est,[15 15]),clim)
%axis equal

%% Task 7.2: fit spatio-temporal receptive field
par.temp = [1 0.1 pi/2 10];

% get spike counts
[c s w_true] = sampleLnp(par);
%w_true = reshape(w_true,225,[]);

% fit receptive field
w_est = fitRf(c,s,10);
%w_est = reshape(w_est,225,[]);

% visualize true and estimated receptive field (on same scale) for the
% different time bins

% ADD YOUR CODE HERE ....
figure()
clim = [min(min([w_true, w_est])), max(max([w_true, w_est]))];
clim1 = [min(min(w_true)), max(max(w_true))];
clim2 = [min(min(w_est)), max(max(w_est))];

for i = 1:10
%     w_t = reshape(w_true(:,i),[15 15]);
%     w_e = reshape(w_est(:,i),[15 15]);
    subplot(2,10,i)
    imagesc(reshape(w_true(:,i),[15 15]),clim1)
    subplot(2,10,i+10)
    imagesc(reshape(w_est(:,10-i+1),[15 15]),clim2)
end


%% Task 7.3: recover space and time kernels

% space-time separation of true receptive field
[ws wt] = sepSpaceTime(w_true);
[ws_est wt_est] = sepSpaceTime(w_est);

% visualize true and estimated spatial receptive field (on same scale) and
% the true and estimated time kernels


clim = [min(min([ws, ws_est])), max(max([ws, ws_est]))];

% ADD YOUR CODE HERE ....

% for the actual figure I'm not sure which thing to do...so I'll use the
% true w
[U,S,V] = svd(w_true);
figure('Name','Figure 3');
subplot(2,2,[1 2]);
plot(diag(S)); title('Singular Values');
subplot(2,2,3);
plot(V(:,1));title('Temporal kernel');
subplot(2,2,4);
imagesc(reshape(U(:,1),15,15));title('Spatial kernel');

figure; subplot(2,1,1); imagesc(reshape(ws,15,15),clim); title('Real Spatial Kernel');
subplot(2,1,2); imagesc(reshape(ws_est,15,15),clim); title('Est Spatial Kernel');

% it is possible that SVD inverts the temporal component
% if the peak points downward, flip sign as needed:
wt_est = wt_est * sign(mean(wt_est));

figure; subplot(2,1,1); plot(wt); title('Real Time Kernel');
subplot(2,1,2); plot(wt_est); title('Est Time Kernel');

%% task 7.4: fit spatio-temporal receptive field to data

data = load('rf_data.mat');

c = data.spk;
s = data.stim;

% fit receptive field
figure()
for shift = 1 : 10;
    w_est = fitRf(c(shift:end),s(:,1:end-shift+1),1);
    subplot(3, 4, shift)
    imagesc(reshape(w_est, 15, 15))
end

% ADD YOUR CODE HERE ....


