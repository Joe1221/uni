% Stephan Hilb, 2706616
% Führende Nullen in den Koeffizienten werden gestrichen
function [q, r] = my_polydiv(f, g)
	g = g(find(g,1,'first'):end);
	n = length(f) - 1; m = length(g) - 1;

	i = 1; 
	while (n - i + 1 >= m)
		q(i) = f(i) / g(1);
		f(i : i + m) -= q(i) * g;
		i++;
	end

	q = q(find(q,1,'first'):end);
	r = f(find(f,1,'first'):end);
end
