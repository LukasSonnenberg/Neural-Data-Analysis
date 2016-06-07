function [f df] = Gaborfit(p,c,s,tsteps)
w = real(Gabor(p));
sa = sta(w,c,s,tsteps);
wi = zeros(1,length(w)*tsteps);
si = repmat(s,[tsteps,1]);
% f = 0;
% dfi = [];
% for i = 1:tsteps
% %     wi(1+(i-1)*length(w):i*length(w)) = sa(i)*w;
%     [fi dfi] = logLikLnp(w,c,s*sa(i));
%     f = f+fi;
%     fi = [fi; dfi];
% end
% [f df] = logLikLnp(wi,c,si);
[f df] = logLikLnp(w,c,s,sa);

