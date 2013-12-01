classdef ForwardModel < handle
	properties (Constant)
		geom_name = 'geom';
	end
	properties
		model; % Comsol model object
		geom; % Comsol geometry object
		phys; % Comsol physics object
	end
	properties (SetAccess = protected)
		C;
		Omega;
		Gamma;
		D;
		domain;
	end

	methods
		function obj = ForwardModel()
			obj.initModel();
			obj.initGeometry();
			obj.initPhysics();
		end
	end

	methods (Access = private)
		initModel(obj);
		initGeometry(obj);
		initPhysics(obj);
	end

	methods

		showGeometry(obj);

		% TODO: folgende Funktionen in eigene Dateien

		% Äußeres / Omega und C
		function setOuterBoundary (obj, data)
			% Polarkoordinaten als Radien-Vektor
			if isvector(data)
				obj.C.setDataPolarEq(data);
			end
			% Kartesische Koordinaten als n×2 Vektor
			if ismatrix(data) && size(data, 2) == 2
				obj.C.setData(data);
			end
		end

		function setInnerBoundary (obj, data)
			% Polarkoordinaten als Radien-Vektor
			if isvector(data)
				obj.Gamma.setDataPolarEq(data);
			end
			% Kartesische Koordinaten als n×2 Vektor
			if ismatrix(data) && size(data, 2) == 2
				obj.Gamma.setData(data);
			end
		end

		function setFValue (obj, data)
			% Funktion als symbolischer Ausdruck
			if ischar(data)
				obj.phys.feature(obj.C.name).set('r', data);
			end
			% TODO: Funktion als Interpolation von Messdaten
		end

		function run (obj, data)
			% TODO: Auslagern in Methoden
			% ============ MESH ============
			fprintf('Generating Mesh ... ');

			mesh = obj.model.mesh.create('mesh', obj.geom_name);
			mesh.feature.create('ftri1', 'FreeTri');
			mesh.feature('size').set('hauto', '5'); % Gitterauflösung: 1-9 (fine - coarse)

			mesh.run;
			mphmesh(obj.model, 'mesh');

			fprintf('finished\n');
			% ============ STUDY ============
			fprintf('Running Study ... ');

			study = obj.model.study.create('std1');
			study.feature.create('st1', 'Stationary');

			study.run;

			fprintf('finished\n');

			% ============ PLOT ============
			fprintf('Evaluating Result ... ');

			pg1 = obj.model.result.create('pg1', 2);
			pg1.feature.create('surf1', 'Surface');

			pg1.run;
			mphplot(obj.model, 'pg1');

			fprintf('finished\n');

		end
	end
end
