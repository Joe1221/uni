function [z, k] = findroot (z, kmax, epstol)
	f = @(x,y)( [x^4-6*x^2*y^2+y^4-1; 4*x^3*y - 4*x*y^3] );
	% hardcoded for efficiency
	iter = @(x,y)( \
		[(x/4)*((x^2-3*y^2)/(x^2+y^2)^3+3) ;
		 (y/4)*((y^2-3*x^2)/(y^2+x^2)^3+3)]
	);

	k = 0;
	while (norm(f(z(1), z(2))) > epstol && k < kmax)
		z = iter(z(1), z(2));
		k++;
	end
end
