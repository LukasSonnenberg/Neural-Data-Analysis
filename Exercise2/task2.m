% prepare data
clear all
close all
hold off
set(0,'DefaultFigureWindowStyle','docked')

load('NDA_task1_results.mat')

%% Generate Toy Data
N = 100;

mu1 = [0;0];
mu2 = [5;1];
mu3 = [0;2];

sigma1 = [1 0; 0 1];
sigma2 = [2 1; 1 2];
sigma3 = [1 -0.5; -0.5 2];

pi1 = 0.3;
pi2 = 0.5;
pi3 = 0.2;

g1 = mvnrnd(mu1,sigma1,N*pi1);
g2 = mvnrnd(mu2,sigma2,N*pi2);
g3 = mvnrnd(mu3,sigma3,N*pi3);

hold on
plot(g1(:,1),g1(:,2),'r.')
plot(g2(:,1),g2(:,2),'b.')
plot(g3(:,1),g3(:,2),'g.')
plot([mu1(1),mu2(1),mu3(1)],[mu1(2),mu2(2),mu3(2)],'ko')
hold off

b = [g1; g2; g3];

%% 
%[mu, Sigma, priors, df, assignments] = sortSpikes(b);
D = size(b,2);
K = 3; % erfordert noch Arbeit

mu = zeros(K,D);
Sigma = zeros(D,D,K);
for i=1:D
    Sigma(i,i,:) = 10;
end
assignments = zeros(1,K);
df = inf;   % you don't need to use this variable unless you want to 
            % implement a mixture of t-distributions
neurons = zeros(size(b,1),K);
            
            
%% Set starting Points 
%of mu (random) in range of each dimension
for i = 1:D
    mu(:,i) = min(b(:,i)) + rand(K,1)*(max(b(:,i))-min(b(:,i)));
end
%of the prior (every one the same), is this the right variable?
priors = ones(1,K)/K;

%% initial log likelihood
%has yet to be done (maybe) 
hold on
plot(mu(:,1),mu(:,2),'kx')
hold off

%% EM
for i = 1:20 % length should be optimized and not like this
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
        %gamma(l,:) = gamma(l,:)/sum(gamma(l,:));
        gamma2(l,:) = gamma(l,:) == max(gamma(l,:));
    end
    
    gamma = bsxfun(@rdivide, gamma, sum(gamma,2));    
    
    %M-Step
    N = sum(gamma,1);
    for j = 1:K
        new_mu(j,:) = 1/N(j)*sum(bsxfun(@times,gamma(:,j),b));
        
        %b_mu = bsxfun(@minus,b,new_mu(j,:));
        %new_Sigma(:,:,j) = 1/N(j)*sum(bsxfun(@times,gamma(:,j),b_mu'*b_mu));
        for l = 1:size(b,1)
            b_mu = b(l,:) - new_mu(j,:);
            new_Sigma(:,:,j) = new_Sigma(:,:,j) + 1/N(j)*(b_mu'*b_mu)*gamma(l,j);
        end
       % new_Sigma =  1/N(j)*new_Sigma;
        
        new_priors(j) = N(j)/size(b,1);
    end
    
    figure(i+1)    
    hold on
    colors = ['r';'b';'g'];
    for j=1:K
        plot(b(gamma2(:,j)==1,1),b(gamma2(:,j)==1,2),'.','color',colors(j))
    end
    plot(mu(:,1),mu(:,2),'ko')
    plot(new_mu(:,1),new_mu(:,2),'kx')
    hold off
    
    loglike = 0;
    for l = 1:size(b,1)
        for j = 1:K
            loglike = loglike + log(sum(new_priors.*mvnpdf(b(l,:),mu(j,:),Sigma(:,:,j))));
        end
    end 
    mu = new_mu;
    Sigma = new_Sigma;
    priors = new_priors;
end
hold on

hold off
