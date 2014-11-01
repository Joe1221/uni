f = @(x1, x2) 5*pi^2*sin(pi.*x1).*sin(2*pi.*x2);
g = @(x1, x2) 0;

clear fd;
fd = FDSquaresSimple(f, g);

H = [2^-2, 2^-4, 2^-8];
for i = 1:3
	subplot(1,3,i);
	fd.initialize(H(i));
	fd.solve();
	h = fd.plot();
	if (i == 3); set(h, 'EdgeColor', 'none'); end
end
