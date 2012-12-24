% Stephan Hilb, 2706616

f = @(x) 1./(1+x);
a = 0; b = 1; q = 2; kmax = 5;

br = @(h) (h/2) * (f(a) + f(b)) + h * sum(f(linspace(a, b, (b-a)/h - 1)));

for k = 0:kmax
	H(k+1) = (b-a) / 2^k;
end

B = richardson_extrapol(br, H, q);

B(1,:)
B(1,:) - ones(1,kmax+1)*log(2)
