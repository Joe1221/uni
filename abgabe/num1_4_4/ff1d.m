% Stephan Hilb, 2706616

function c = ff1d (f)
	N = length(f);
	if (N == 1)
		c = f;
		return;
	end

	D_N2 = diag( exp( (0:-1:-(N/2 - 1)) * i * 2 * pi / N) );

	c_even = ff1d(f(1 : 2 : end));
	c_odd = ff1d(f(2 : 2 : end));

	tmp = D_N2 * c_odd;

	c = zeros(N,1);
	c(1 : N/2) = 0.5 * (c_even + tmp);
	c(N/2 + 1 : N) = 0.5 * (c_even - tmp);
end
