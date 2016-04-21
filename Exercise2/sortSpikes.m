function [mu, Sigma, priors, df, assignments, loglike] = sortSpikes(b)
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

trials = 15; %how often the EM-algorithm runs
runs = 40; %steps of each EM-algorithm

mu = zeros(K,D);
Sigma = zeros(D,D,K);
loglike = zeros(trials,runs);

for i=1:D
    Sigma(i,i,:) = 10;
end
df = inf;   % you don't need to use this variable unless you want to 
            % implement a mixture of t-distributions
priors = ones(1,K)/K;
min_loglike = inf;
max_loglike = -inf;

%% EM

break_loop = 0;

for t = 1:trials
    for i = 1:D
        mu(:,i) = min(b(:,i)) + rand(K,1)*(max(b(:,i))-min(b(:,i))); %first random mu locations
    end
    for i = 1:runs
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
                new_Sigma(:,:,j) = new_Sigma(:,:,j) + 1/N(j)*gamma(l,j)*((b(l,:)-new_mu(j,:))'*(b(l,:)-new_mu(j,:)));
            end
            new_priors(j) = N(j)/size(b,1);
        end
        
        %check if Sigma is valid, break otherwise
        for j = 1:K
            if sum(diag(Sigma(:,:,j))<0.1) > 0
                loglike(t,i:end) = nan;
                break_loop = 1;
            end
            if sum(sum(Sigma(:,:,j)^-1)) == inf
                loglike(t,i:end) = nan;
                break_loop = 1;
            end
        end
        
        if break_loop == 1
            break
        end
        
        %get loglikelihood, break if it is -inf and fill vector with NaNs
        for l = 1:size(b,1)
            likelihood = 0;
            for j = 1:K
                likelihood = likelihood + new_priors(j)*mvnpdf(b(l,:),mu(j,:),Sigma(:,:,j));
            end
            loglike(t,i) = loglike(t,i) + log(likelihood);
        end

        if loglike(t,i) == -inf
            loglike(t,i:end) = nan;
            break
        end
        
        if i>3
            if diff(loglike(t,i-1:i)) < 1.0
                loglike(t,i:end) = loglike(t,i);
                break
            end
        end
        
        %update Parameters
        mu = new_mu;
        Sigma = new_Sigma;
        priors = new_priors;
    end
    %get parameters of highest likelihood
    if loglike(t,end) > max_loglike
        max_loglike = loglike(t,end);
        max_mu = mu;
        max_Sigma = Sigma;
        max_priors = priors;
        max_gamma = gamma2;
    end
end

mu = max_mu;
Sigma = max_Sigma;
priors = max_priors;
assignments = sum(bsxfun(@times,max_gamma,1:K),2);
disp(['Maximum Likelihood is ', num2str(max_loglike)])
