function initPhysics (obj)

	% ============ PHYSIK ============
	fprintf('Creating Physics ... ');

	% Physik erzeugen und Parameter der DGL festlegen
	obj.phys = obj.model.physics.create('ph', 'CoefficientFormPDE', obj.geom_name);
	ph_eq = obj.phys.feature.create('leq', 'LaplaceEquation', 2);
	ph_eq.selection.named(strcat(obj.geom_name, '_', obj.domain.name, '_dom')); % DGL nur auf der domain (Omega ohne D)


	% Dirichlet boundary condition for outer boundary C
	ph_bnd_C = obj.phys.feature.create(strcat(obj.C.name, '_dirichlet'), 'DirichletBoundary', 1);
	ph_bnd_C.selection.named(strcat(obj.geom_name, '_', obj.Omega.name, '_bnd'));
	ph_bnd_C.active(false); % gets activated in setDirichletOuterData()
	% Neumann boundary condition for outer boundary C
	ph_bndcond_neumann_C = obj.phys.feature.create(strcat(obj.C.name, '_neumann'), 'FluxBoundary', 1);
	ph_bndcond_neumann_C.selection.named(strcat(obj.geom_name, '_', obj.Omega.name, '_bnd'));
	ph_bndcond_neumann_C.active(false); % gets activated in setNeumannOuterData()

	% Randbedingung f�r Gamma (u = 0)
	ph_bnd_Gamma = obj.phys.feature.create(strcat(obj.Gamma.name, '_dirichlet'), 'DirichletBoundary', 1);
	ph_bnd_Gamma.selection.named(strcat(obj.geom_name, '_', obj.D.name, '_bnd'));
	ph_bnd_Gamma.active(false); % gets activated in setDirichletInnerData()
	% Neumann boundary condition for outer boundary C
	ph_bndcond_neumann_Gamma = obj.phys.feature.create(strcat(obj.Gamma.name, '_neumann'), 'FluxBoundary', 1);
	ph_bndcond_neumann_Gamma.selection.named(strcat(obj.geom_name, '_', obj.D.name, '_bnd'));
	ph_bndcond_neumann_Gamma.active(false); % gets activated in setNeumannInnerData()


	fprintf('finished.\n');

end
