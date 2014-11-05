f = @(x1, x2) 5*pi^2*sin(pi.*x1).*sin(2*pi.*x2);
g = @(x1, x2) 0;

clear fd;
fd = FDSquaresSimple(f, g);

H = [2^-2, 2^-4, 2^-8];
for i = 1:3
	figure(i)
	set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 6])
	%subplot(1,3,i);
	fd.initialize(H(i));
	fd.solve();
	h = fd.plot();
	if (i == 3); set(h, 'EdgeColor', 'none'); end
end

