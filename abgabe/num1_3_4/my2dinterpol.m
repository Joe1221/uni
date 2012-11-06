function [px, py] = my2dinterpol(x, y)
	n = length(x) - 1;
	px = polyfit(0:n, x, n);
	py = polyfit(0:n, y, n);
end
