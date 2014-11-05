f = @(x1, x2) 5*pi^2*sin(pi.*x1).*sin(2*pi.*x2);
g = @(x1, x2) 0;
u = @(x1, x2) sin(pi*x1).*sin(2*pi*x2);

clear fd;
fd = FDSquaresSimple(f, g);

n = 70;
H = 1 ./ ((1:n) + 0);
err = zeros(1, n);

for i = 1:n
	fd.initialize(H(i));
	fd.solve();
	err(i) = fd.computeError(u);
end

h = stem(H, err ./ (H.^2));

set(gca, 'XScale', 'log');
set(gca, 'XDir', 'reverse');
set(h, 'MarkerSize', 3);
%title('$\frac{\|u_d - u\|_\infty}{h^2}$', 'Interpreter', 'tex');

% Error Table

n = 9;
H = 2.^-(2:n+1);
err = zeros(1, n);

for i = 1:n
	fd.initialize(H(i));
	fd.solve();
	err(i) = fd.computeError(u);
end
format long
[H', err']
