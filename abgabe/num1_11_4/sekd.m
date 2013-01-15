% Stephan Hilb, 2706616

function x = sekd (f, xl, x, d, kmax, epstol)
	if (d)
		omega = @(k) 1/(1+10*e^(-k));
	else
		omega = @(k) 1;
	end
	k = 1;
	while (abs(f(x)) > epstol && k < kmax)
		tmp = x;
		x = x - omega(k) * (f(x)*(x - xl))/(f(x) - f(xl))
		xl = tmp;
		k++;
	end
end
