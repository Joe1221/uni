% Stephan Hilb, 2706616

output_precision(5);
sekd(@(x) atan(x-1), 4, 4.01, 0, 20, 10^(-10));
sekd(@(x) atan(x-1), 4, 4.01, 1, 20, 10^(-10));

