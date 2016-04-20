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

trials = 10;
runs = 30;

mu = zeros(K,D);
Sigma = zeros(D,D,K);
loglike = zeros(trials,runs);

for i=1:D
    Sigma(i,i,:) = 10;
end
assignments = zeros(1,K);
df = inf;   % you don't need to use this variable unless you want to 
            % implement a mixture of t-distributions
%neurons = zeros(size(b,1),K);     
priors = ones(1,K)/K;
min_loglike = 0;

%% EM
break_loop = 0;
for t = 1:trials
    for i = 1:D
        mu(:,i) = min(b(:,i)) + rand(K,1)*(max(b(:,i))-min(b(:,i)));
    end
    for i = 1:runs % length should be optimized and not like this
        new_mu = mu*0;
        new_Sigma = Sigma*0;
        new_priors = priors*0;

        %E-Step
        gamma = zeros(size(b,1),K);
        gamma2 = zeros(size(b,1),K);
        for l = 1:size(b,1)
            for j = 1:K     
                gamma(l,j) = priors(j)*mvnpdf(b(l,:),mu(j,:), Sigma(:,:,j));
            end   
            gamma2(l,:) = gamma(l,:) == max(gamma(l,:));
        end

        gamma = bsxfun(@rdivide, gamma, sum(gamma,2));    

        %M-Step
        N = sum(gamma,1);
        for j = 1:K
            new_mu(j,:) = 1/N(j)*sum(bsxfun(@times,gamma(:,j),b));
            for l = 1:size(b,1)
                b_mu = b(l,:) - new_mu(j,:);
                new_Sigma(:,:,j) = new_Sigma(:,:,j) + 1/N(j)*(b_mu'*b_mu)*gamma(l,j);
            end
            new_priors(j) = N(j)/size(b,1);
        end
        
        for j = 1:K
            if sum(diag(Sigma(:,:,j)) < 0.1) > 0
                break_loop = 1;
            end
        end 
        if break_loop == 1
            break
        end
        
        for l = 1:size(b,1)
            for j = 1:K
                loglike(t,i) = loglike(t,i) + log(sum(new_priors.*mvnpdf(b(l,:),mu(j,:),Sigma(:,:,j))));
            end
        end
        if loglike(t,i) == -inf
            loglike(t,i:end) = nan;
            break
        end
        
        mu = new_mu;
        Sigma = new_Sigma;
        priors = new_priors;
    end
    if loglike(t,end) < min_loglike
        min_mu = mu;
        min_Sigma = Sigma;
        min_priors = priors;
        min_gamma = gamma2;
    end
end

mu = min_mu;
Sigma = min_Sigma;
priors = min_priors;
assignments = sum(bsxfun(@times,min_gamma,1:K),2);