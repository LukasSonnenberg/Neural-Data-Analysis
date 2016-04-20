function [mu, Sigma, priors, df, assignments] = sortSpikes(b)
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


D = size(b,2);
K = 3; % erfordert noch Arbeit

mu = zeros(K,D);
Sigma = zeros(D,D,K);
for i=1:D
    Sigma(i,i,:) = 1;
end
assignments = zeros(1,K);
df = inf;   % you don't need to use this variable unless you want to 
            % implement a mixture of t-distributions

%% Set starting Points 
%of mu (random) in range of each dimension
for i = 1:D
    mu(:,i) = min(b(:,i)) + rand(K,1)*(max(b(:,i))-min(b(:,i)));
end
%of the prior (every one the same), is this the right variable?
priors = ones(1,K)/K;

%% initial log likelihood
%has yet to be done (maybe)

%% EM
for i = 1:50 % length should be optimized and not like this
    %E-Step
    gamma = zeros(size(b,1),K,D);
    for l = 1:size(b,1)
        for j = 1:K
            gamma(l,j,:) = priors(j)*mvnpdf(b(l,:),mu(j,:), Sigma(:,:,j));
        end
        gamma(l,:,:) = gamma(l,:,:)/sum(gamma(l,:,:),2);
    end
    
    %M-Step
    N = sum(gamma,1);
    for j = 1:K
        mu(j,:) = 1/N(j)*sum(gamma(:,j,:).*b); %might be wrong
        Sigma(:,:,j) = 1/N(j)*sum(gamma(:,j,:).*((b-mu(j,:))*(b-mu(j,:))'));
        priors(j) = N(j)/size(b,1);
    end
end
    

