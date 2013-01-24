% Stephan Hilb, 2706616
function q = my_polydiff(p)
	q = p .* [length(p)-1:-1:0];
	q(end) = [];
end
