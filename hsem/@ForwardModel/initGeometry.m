function initGeometry (obj)
	% Geometrie erstellen
	% ===================
	fprintf('Generating Geometry ... ');
	%obj.geom = ComsolGeometry(obj.model, obj.geom_name);
	obj.geom = obj.model.geom.create(obj.geom_name, 2);
	% Stelle Polarkoordinaten bereit als polar.r, polar.phi
	obj.model.coordSystem().create('polar', obj.geom_name, 'Cylindrical');

	% Äußeres / Omega und C (daten werden später gesetzt)
	obj.C = Boundary(obj.geom, 'C');
	obj.Omega = Domain(obj.geom, 'Omega', obj.C);
	% Inneres / D und Gamma (daten werden später gesetzt)
	obj.Gamma = Boundary(obj.geom, 'Gamma');
	obj.D = Domain(obj.geom, 'D', obj.Gamma);

	% DGL-Gebiet / Omega ohne D
	obj.domain = Domain(obj.geom, 'domain', obj.Omega, obj.D);

	fprintf('finished.\n');
end
