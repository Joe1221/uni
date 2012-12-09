% Stephan Hilb, 2706616

for i = 0:8
	f = @(x) x.^i;
	I = 1 / (i + 1);
	for n = 1:6
		E(i+1,n) = abs(I - newtoncotes(f, n));
	end
end
E
