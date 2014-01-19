function [M] = eqd_radii_to_points(r)
	% Konvertiert Radienvektor zu kartesischen Koordinaten
	% Gegeben: r ist Vektor equidistanter Radien
	% Ausgabe: Matrix M mit den kartesischen Koordinaten zu den Radien

	n = length(r);
	phi0 = 2*pi/n;
	M = zeros(n,2);

	for k = 1:n
		phi = phi0 * (k-1);
		M(k,1) = r(k)*cos(phi);
		M(k,2) = r(k)*sin(phi);
	end
end
