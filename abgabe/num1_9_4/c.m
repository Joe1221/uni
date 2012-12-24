% Stephan Hilb, 2706616

n = [50, 500, 5000, 10000];
N = 10;

area = zeros(size(n));
for i = 1:length(n)
	for j = 1:N
		area(i) += mc_int(n(i), @(phi) 0.4 + 0.1*sin(8*phi));
	end
	area(i) /= N;
end
area
