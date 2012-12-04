% Stephan Hilb, 2706616

for i = 0:8
	f = @(x) x.^i;
	for n = 1:6
		I(i+1,n) = newtoncotes(f, n);
	end
end
I
