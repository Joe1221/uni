function initPhysics (obj)

	% ============ PHYSIK ============
	fprintf('Creating Physics ... ');

	% Physik erzeugen und Parameter der DGL festlegen
	obj.phys = obj.model.physics.create('ph', 'CoefficientFormPDE', obj.geom_name);
	ph_eq = obj.phys.feature.create('leq', 'LaplaceEquation', 2);
	ph_eq.selection.named(strcat(obj.geom_name, '_', obj.domain.name, '_dom')); % DGL nur auf der domain (Omega ohne D)

	% Randbedingung für C (u = f)
	ph_bnd_C = obj.phys.feature.create(strcat(obj.C.name, '_dirichlet'), 'DirichletBoundary', 1);
	ph_bnd_C.selection.named(strcat(obj.geom_name, '_', obj.Omega.name, '_bnd'));

	% Randbedingung für Gamma (u = 0)
	ph_bnd_Gamma = obj.phys.feature.create(obj.Gamma.name, 'DirichletBoundary', 1);
	ph_bnd_Gamma.selection.named(strcat(obj.geom_name, '_', obj.D.name, '_bnd'));
	obj.setDirichletInnerData('0');

	fprintf('finished.\n');

end
