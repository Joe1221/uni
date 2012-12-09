% Stephan Hilb, 2706616

a = -1;
b = 1;

N = [4,8,16,32];
clf;
for i = (1:4)
	e(i) = 0;
	n = N(i);
    subplot(4, 1, i);
	title("abc");

	X = linspace(a, b, n + 1);
	H = diff(X);
	Y = 1 ./ (1 .+ 12 * X.^2);
	S = myspline(transpose(X), transpose(Y));

	plot(linspace(a,b), 1 ./ (1 .+ 12 * linspace(a,b).^2));


	hold on;
	for j = (1:n)
		x = linspace(X(j), X(j+1));
		y = polyval(S(:,j), linspace(0, H(j)));
		plot(x, y);
		xe = (X(j):0.001:X(j+1));
		ye = 1 ./ (1 .+ 12 * xe.^2);
		se = polyval(S(:,j), (0:0.001:H(j)));
		etmp = max(abs(ye - se));
		e(i) = max(e(i), etmp);
	end
	hold off

	if i > 1
		eoc(i-1) = log(e(i-1) / e(i)) / log( (2/N(i-1)) / (2/N(i)) );
	end
end
e
eoc
