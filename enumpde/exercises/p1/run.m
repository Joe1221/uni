
clear fd

f = @(x1, x2) 5*pi^2*sin(pi.*x1).*sin(2*pi.*x2);
g = @(x1, x2) x1.*x2.*(3-x1).*(3-x2);
g = @(x1, x2) 0;

fd = FDSquaresSimple(f, g);


fd.init(2^-2);
fd.solve();
figure(1)
h = fd.plot();

fd.init(2^-4);
fd.solve();
figure(2)
h = fd.plot();

fd.init(2^-8);
fd.solve();
figure(3)
h = fd.plot();
set(h, 'EdgeColor', 'none');

