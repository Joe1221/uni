% Stephan Hilb, 2706616

B = bisektion(@(x) cos(x)/sin(x), 27, 1, 2);
N = newton(@(x) cos(x)/sin(x), 27, @(x) -csc(x)^2, 1);
Berr = abs(B - pi/2);
Nerr = abs(N - pi/2);

out(:,1) = B;
out(:,2) = Berr;
out(:,3) = Nerr;
out(:,4) = N;
output_precision(7);
out
