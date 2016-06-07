function w = Gabor(p)
w = zeros(15,15);
S = p(1);
F = p(2);
W = p(3);
P = p(4);

x_vec = -7:7;
y_vec = -7:7;

size = 7;

for x=x_vec
    for y=y_vec
        w(size+x+1,size+y+1)=exp(-pi*S^2*(x*x+y*y))*...
            (exp(1i*(2*pi*F*(x*cos(W)+y*sin(W))+P))-exp(-pi*(F/S)^2+1i*P));
    end
end
w = reshape(w,1,[]);