% Stephan Hilb, 2706616
function z = realpolyroot(p, kmax)
	% Führende Nullen streichen
	p = p(find(p,1,'first'):end);
	n = length(p) - 1;

	% Falls Polynom konstant, keine Nullstellen
	if n <= 0
		z = [];	return;
	end

	% Normieren und Ableitung
	p = p ./ p(1);
	dp = my_polydiff(p);

	% Startwert := Obere Schranke für Nullstelle
	x = min( \
		max(1, sum(abs(p(2:end)))), \
		max(abs(p(end)), sum(1 + max(p(2:end-1)))) \ % sum-Hack, sonst maximum leer
	);

	% Newton-Verfahren
	for i = 1:kmax
		x = x - polyval(p, x) / polyval(dp, x);
	end

	% Rekursiver Aufruf
	z(1) = x;
	z(2:n) = realpolyroot(my_polydiv(p, [1,-x]), kmax);
end
