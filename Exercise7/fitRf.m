function [rf,x,fval,sa] = fitRf(sp,stim,tsteps)

% rf = fitRf(sp,stim)
%   estimate the linear receptive field rf from the binned spike train sp 
%   and the stimulus stim for an LNP neuron with exponential nonlinearity.
%
%   sp: 1 x ceil(T/dt)          vector of spike counts in time bins of width dt
%
%   stim: 225 x ceil(T/dt)      matrix with +1/-1 entries indicating which
%                               pixels of the stimulus were brighter or less 
%                               bright than the background in each time frame
%
%   tsteps: scalar              specifies number of timesteps into the past
%
%   rf: 225 x tsteps            matrix containing the receptive field of the neuron
%                               at tsteps time lags of size dt
%
% PHB 2012-06-21

p0 = [0.25 0.1 pi/2 pi/2];
%p0 = [0.2 0.05 .3 pi/2];

% [X, fX, i] = minimize(p0,@(p0)(logLikLnp(real(Gabor(p0)),c,s)),1000)
% [x,fval] = fminsearch(@(p0)(logLikLnp(real(Gabor(p0)),sp,stim)),p0);
[x,fval] = fminsearch(@(p0)(Gaborfit(p0,sp,stim,tsteps)),p0);

w = real(Gabor(x));
sa = sta(w,sp,stim,tsteps);

rf = w'*sa;

% w_new = rf;
% 
% clim = [min(min(w_new)), max(max(w_new))];
% clim2 = [min(min(w_true)), max(max(w_true))];
% for i = 1:10
% subplot(2,10,i)
% imagesc(reshape(w_true(:,i),[15 15]),clim2)
% subplot(2,10,i+10)
% imagesc(reshape(w_new(:,10-i+1),[15 15]),clim)
% end
