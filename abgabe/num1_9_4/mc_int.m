% Stephan Hilb, 2706616

function A = mc_int(n, rh)
	xi = rand(2, n);

	% Flaeche zeichnen als gefuelltes Polygon
	phi = linspace(0, 2 * pi, 1000);
	clf, fill(rh(phi).*cos(phi) + 0.5, rh(phi).*sin(phi) + 0.5, 'r');
	% Plot der Zufallszahlen
	hold on, plot(xi(1,:), xi(2,:), '0.', 'markersize', 8), hold off;

	% Flaechenberechnung
	xi = xi - (0.5 * ones(2, n));
	r = sqrt(xi(1,:).^2 + xi(2,:).^2); 
	phi = atan(xi(2,:) ./ xi(1,:));
	A = sum(r <= rh(phi)) / n;
end
