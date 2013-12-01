function initPhysics (obj)

	% ============ PHYSIK ============
	fprintf('Creating Physics ... ');

	% Physik erzeugen und Parameter der DGL festlegen
	obj.phys = obj.model.physics.create('ph', 'CoefficientFormPDE', obj.geom_name);
	obj.phys.selection.named(strcat(obj.geom_name, '_', obj.domain.name, '_dom')); % DGL nur auf der domain (Omega ohne D)
	ph_eq = obj.phys.feature('cfeq1');
	ph_eq.set('c', -1);
	ph_eq.set('a', 0);
	ph_eq.set('f', 0);   % Rechte Seite, gleich 0
	ph_eq.set('ea', 0);
	ph_eq.set('da', 0);
	ph_eq.set('al', [0 0]); % al, be, ga sind vektoren
	ph_eq.set('be', [0 0]);
	ph_eq.set('ga', [0 0]);

	% Randbedingung für C (u = f)
	ph_bnd_C = obj.phys.feature.create(obj.C.name, 'DirichletBoundary', 1);
	ph_bnd_C.selection.named(strcat(obj.geom_name, '_', obj.Omega.name, '_bnd'));
	%ph_bnd_C.set('r', 'x^2-2*y+2');
	%ph_bnd_C.set('r', 'cos(3*polar.phi) + 2*sin(polar.phi)');
	%ph_bnd_C.set('r', 'f(polar.r, polar.phi)');
	obj.setFValue('cos(3*polar.phi) + 2*sin(polar.phi)');

	% Randbedingung für Gamma (u = 0)
	ph_bnd_Gamma = obj.phys.feature.create(obj.Gamma.name, 'DirichletBoundary', 1);
	ph_bnd_Gamma.selection.named(strcat(obj.geom_name, '_', obj.D.name, '_bnd'));
	ph_bnd_Gamma.set('r', '0');

	fprintf('finished\n');

end
