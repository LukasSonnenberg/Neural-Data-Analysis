% prepare data
clear all
close all
hold off
set(0,'DefaultFigureWindowStyle','docked')

%% Generate Toy Data
N = 1000;

mu1 = [0;0];
mu2 = [5;1];
mu3 = [0;2];

sigma1 = [1 0; 0 1];
sigma2 = [2 1; 1 2];
sigma3 = [1 -0.5; -0.5 2];

pi1 = 0.3;
pi2 = 0.5;
pi3 = 0.2;

s = rng;
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

load('NDA_task1_results.mat')
b = b(1:100,:);

%% 
tic
[mu, Sigma, priors, df, assignments, loglike] = sortSpikes(b);
toc

%%


%%

figure()
hold on
for i = 1:max(assignments)
    plot(b(assignments == i,1),b(assignments == i,2),'.')
end
hold off
