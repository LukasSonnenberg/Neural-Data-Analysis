function plotSeparation(b, mu, Sigma, priors, assignment, varargin)
% Plot cluster separation by projecting on LDA axes
%   plotSeparation(b, mu, Sigma, priors, assignment) visualizes the cluster
%   separation by projecting the data on the LDA axis for each pair of
%   clusters. Each column is normalized such that the left (i.e. first)
%   cluster has zero mean and unit variances. The LDA axis is estimated
%   from the model.
colors = [0 0 0; 0 0 1; 0 1 0; 1 0 0; 0 1 1; 1 0 1; 1 1 0; .5 .5 .5; 0 0 .5];
figure;
C = size(mu,1);
for i = 1:C
    for j = 1:C
        if i ~= j
            subplot(C,C,i+(j-1)*C);
            w = LD(b(assignment==i,:),b(assignment==j,:));
            c1_w = b(assignment==i,:)*w';
            c2_w = b(assignment==j,:)*w';
            norm_mean = mean(c1_w);
            norm_cov = var(c1_w);
            c1_w = (c1_w - norm_mean)/norm_cov;
            c2_w = (c2_w - norm_mean)/norm_cov;
            plot_max = max(max(c1_w),max(c2_w));
            plot_min= min(min(c1_w),min(c2_w));
            centers = linspace(plot_min, plot_max, 100); % 100 is random, we can change it
            hist(c1_w,centers);
            set_hist({'FaceColor',colors(i,:),'EdgeColor','none'});
            hold on
            hist(c2_w,centers);
            set_hist({'FaceColor',colors(j,:),'EdgeColor','none'});
        end
    end
end
end
function [w] = LD(d1, d2)
    mu1 = mean(d1,1);
    mu2 = mean(d2,1);
    d1 = d1 - kron(ones(size(d1,1),1),mu1);
    d2 = d2 - kron(ones(size(d2,1),1),mu2);
    S = cov(cat(1,d1,d2));
    w = S\(mu1-mu2)';
    w = w';
end
% yes this is a stupid hack but I didn't want to be dependent on matlab
% 2014b+
function [] = set_hist(props)
cur = get(gca,'child');
set(cur(1),props{:});
end