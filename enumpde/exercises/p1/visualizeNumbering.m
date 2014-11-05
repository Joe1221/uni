
f = @(x1, x2) 5*pi^2*sin(pi.*x1).*sin(2*pi.*x2);
g = @(x1, x2) 0;

clear fd;
fd = FDSquaresSimple(f, g);
fd.initialize(0.25);

% visualize, (0,0) at bottom left, x dir right, y dir top
rot90(fd.pos2idxMap)

