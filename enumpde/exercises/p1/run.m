clear fd

f = @(x1, x2) 5*pi^2*sin(pi.*x1).*sin(2*pi.*x2);
g = @(x1, x2) 0;
u = @(x1, x2) sin(pi*x1).*sin(2*pi*x2);

%g = @(x1, x2) x1.*x2.*(3-x1).*(3-x2);


fd = FDSquaresSimple(f, g);

fd.initialize(2^-8);
fd.initialize(1/3);
fd.solve();

%figure(1)
h = fd.plot();
fd.computeError(u);

%fd.initialize(2^-4);
%fd.solve();
%figure(2)
%h = fd.plot();
%
%fd.initialize(2^-8);
%fd.solve();
%figure(3)
%h = fd.plot();
%set(h, 'EdgeColor', 'none');
%

%fd
