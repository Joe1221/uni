% Stephan Hilb, 2706616

function X = newton(f, k, fd, x)
	for i = 1:k
		X(i) = x = x - (f(x)/fd(x));
	end
end
