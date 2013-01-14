% Stephan Hilb, 2706616

function X = bisektion(f, k, a, b)
	for i = 1:k
		X(i) = (a + b)/2;

		if f(a) * f(X(i)) < 0
			b = X(i);
		else
			a = X(i);
		end
	end
end
