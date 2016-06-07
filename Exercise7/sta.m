function sa = sta(w,c,s,t)
sa = zeros(1,t);
c1 = c(t:end);
for i = 1:t
    sa(i) = sum((c1.*(w*s(:,i:end-t+i)))/sum(2*c1));
end