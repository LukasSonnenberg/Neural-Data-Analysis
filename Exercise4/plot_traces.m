function plot_traces(trace1, trace2)
msqe = immse(trace1,trace2);
c = corr(trace1,trace2);
figure()
hold on
plot(trace1,'k')
plot(trace2,'b')
hold off
title(['mean square error=', num2str(msqe),' corr=',num2str(c)]);