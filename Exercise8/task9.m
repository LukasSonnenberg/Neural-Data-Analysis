clear all
close all
set(0,'DefaultFigureWindowStyle','docked')
% task 9
% estimate entropy / evaluate different estimators

sampleSz = [50:20:90 100:50:1000 1000:1000:6000 8000 10000 13000 16000];
nSampleSz = length(sampleSz);
nRuns = 30;

%% case 1: uniform distribution
D = 10;                 % dimensions
N = 2^D;                % number of patterns
p = 1/N * ones(1,N);    % true distribution
H = 10;     % true entropy

for s=1:nSampleSz
    for i=1:nRuns
        samp = ceil(rand(1,sampleSz(s))*N);  % draw a random sample from the uniform distribution
        sampHist = accumarray(samp',1); 
        % need to bring total number up to max possible by padding with
        % zeros
        sampHist = cat(1,sampHist,zeros(length(p)-length(sampHist),1));
        H_mle(s,i) = entropy_mle(sampHist);
        H_mm(s,i) = entropy_mm(sampHist);
        H_cae(s,i) = entropy_cae(sampHist);      
        H_jk(s,i) = entropy_jk(samp);    
        H_est(s,i) = entropy_est(samp);
        [a,~]=modBUBfunc(sum(sampHist),length(sampHist),11,0);
        BUB_est(s,i)=sum(a(sampHist+1))/log(2);
%         BUB_est(s,i)=sum(modBUBfunc(sum(sampHist),length(sampHist),11,1)+1);
    end
end
plot_estimators(H,H_mle,H_mm,H_cae,H_jk,BUB_est,sampleSz,'Uniform Distribution');

%% case 2: zipf distribution
D = 10;                 % dimensions
N = 2^D;                % number of patterns
p = 1./(1:N); p = p/sum(p); % true distribution
H = entropy_mle(p);     % true entropy

fprintf('\n')
for s=1:nSampleSz
    fprintf('.')
    for i=1:nRuns
        samp = sampleHistFun(p,sampleSz(s));
        sampHist = accumarray(samp',1,[N,1]);
        % need to bring total number up to max possible by padding with
        % zeros
        sampHist = cat(1,sampHist,zeros(length(p)-length(sampHist),1));
        H_mle(s,i) = entropy_mle(sampHist);
        H_mm(s,i) = entropy_mm(sampHist);
        H_cae(s,i) = entropy_cae(sampHist);      
        H_jk(s,i) = entropy_jk(sampHist); 
        [a,~]=modBUBfunc(sum(sampHist),length(sampHist),11,1);
        BUB_est(s,i)=sum(a(sampHist+1))/log(2);
    end
end

fprintf('\n')
plot_estimators(H,H_mle,H_mm,H_cae,H_jk,BUB_est,sampleSz,'Zipf Distribution');






