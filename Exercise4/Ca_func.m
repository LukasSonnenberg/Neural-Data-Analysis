function [Ca] = Ca_func(spikes, Ca_0, E_Ca, tau, dt, str,fac)
% a funtion to model the calcium traces, increases for a certain value when
% a spike occures and then saturates to its equlibrium
% Spikes: Firing at each timebin
% Ca_0: starting value
% E_Ca: equlibrium
% tau: time constant
% dt: width of time bin
% str: strength of how much a spike increases the trace
% fac: a factor that determines, until which number of spikes in a time bin
% the str gets weighted more, str is weighted less for firingrates > fac


Ca = zeros(length(spikes),1);
Ca(1) = Ca_0;
Input = (spikes*fac).^(1/fac)*str;
for i = 1:length(spikes)-1
    dCa_dt = (E_Ca-Ca(i))/tau;
    Ca(i+1) = Ca(i) + dt*dCa_dt + Input(i+1);
end