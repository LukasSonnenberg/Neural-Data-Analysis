function [mu, Sigma, priors, df, assignments,allBIC, n_clusters] = sortSpikes(b,varargin)
% Do spike sorting by fitting a Gaussian or Student's t mixture model.
%   [mu, Sigma, priors, df, assignments] = sortSpikes(b) fits a mixture
%   model using the features in b, which is a matrix of size #spikes x
%   #features. The df output indicates the type of model (Gaussian: df =
%   inf, t: df < inf)
%
%   The outputs are (K = #components, D = #dimensions):
%       mu              cluster means (K-by-D)
%       Sigma           cluster covariances (D-by-D-by-K)
%       priors          cluster priors (1-by-K)
%       df              degrees of freedom in the model (Gaussian: inf)
%       assignments     cluster index for each spike (1 to K)

rng(5);

df = inf;   % you don't need to use this variable unless you want to 
            % implement a mixture of t-distributions


% initialize outputs


n_clusters = invarargin(varargin,'n_clusters');
if isempty(n_clusters)
    n_clusters = 2:10;
end
L_struct = {};
for n = n_clusters
    mu = zeros(n,size(b,2));
    Sigma = zeros(size(b,2),size(b,2),n);
    priors = zeros(1,n);
    
    
    % initialize internal variables
    W_ = zeros(size(b,1),n);
    
    
    % randomly partition inputs for initial clustering
    randind = randperm(size(b,1));
    randind = reshape(randind(1:(n*floor(size(b,1)/n))),n,[]);
    for i = 1:n
        mu(i,:) = mean(b(randind(i,:),:),1);
        Sigma(:,:,i) = cov(b(randind(i,:),:) - kron(ones(size(randind,2),1),mu(i,:)));
        priors(i) = 1/n;
    end
    
    L_prev = 0;
    L = 1e6;
    nits = 0;
    while abs(L-L_prev) > 1e-10*L && nits < 200;
        
        L_prev = L;
        % expectation step
        for i = 1:n
            W_(:,i) = priors(i)*mvnpdf(b,mu(i,:),Sigma(:,:,i));
        end
        normalizing = sum(W_,2);
        W_ = W_ ./ repmat(normalizing,1,n);
        
        % maximization step
        N_k = sum(W_,1);
        for i = 1:n
            priors(i) = N_k(i)/size(b,1);
            mu(i,:) = sum(repmat(W_(:,i),1,size(mu,2)).*b,1)/N_k(i);
            Sigma(:,:,i) = (repmat(W_(:,i),1,size(mu,2)).* (b - repmat(mu(i,:),size(b,1),1)))'*(b - repmat(mu(i,:),size(b,1),1))/N_k(i);
        end
        
        % likelihood is just the sum of the matrix W_
        L = sum(sum(W_.*repmat(normalizing,1,n)));
        if ~mod(n,100)
        fprintf('n_clusters: %d, LL: %.2e\n',n, L);
        end
        nits = nits + 1;
    end
    outstruct = struct('mu',mu);
    outstruct.Sigma = Sigma;
    outstruct.priors = priors;
    [~,max_ind] = max(W_,[],2);
    outstruct.BIC = -2*sum(mvnpdf(b,mu(max_ind,:),Sigma(:,:,max_ind))) +  n*3*log(size(b,1));
    outstruct.n = n;
    outstruct.W = W_;
    L_struct = cat(2,L_struct,{outstruct});
end

allBIC = zeros(length(L_struct),1);
for i = 1:length(L_struct)
    allBIC(i) = L_struct{i}.BIC;
end
[~,minind] = min(allBIC);
mu = L_struct{minind}.mu;
Sigma = L_struct{minind}.Sigma;
priors = L_struct{minind}.priors;
W_ = L_struct{minind}.W;
[~,assignments] = max(W_,[],2);

end

function out = invarargin(var,option)

if isempty(find(strcmp(var,option)))
    out = [];
else
    out = var{find(strcmp(var,option))+1};
end
end

