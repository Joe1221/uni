classdef ForwardModel < handle
	% ForwardModel Klasse zum LÃ¶sen des VorwÃ¤rtsproblems
	% Diese Klasse kÃ¼mmert sich um das Erstellen eines Comsol Modells, die
	% Erstellung einer 2D-Geometrie und abstrahiert das Definieren der
	% nÃ¶tigen Randkurven/Gebiete fÃ¼r das VorwÃ¤rtsproblem der Gebietserkennung.

	properties (Constant)
		geom_name = 'geom'; % Comsol tag der Geometrie
	end
	properties
		model; % Comsol model object
		geom; % Comsol geometry object
		phys; % Comsol physics object
		mesh;
		study;
	end
	properties (SetAccess = protected)
		C;
		Omega;
		Gamma;
		D;
		domain;

		pg1;
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
			% Kartesische Koordinaten als nx2 Vektor
			if ismatrix(data) && size(data, 2) == 2
				obj.C.setData(data);
			end
		end

		function setInnerBoundary (obj, data)
			% Polarkoordinaten als Radien-Vektor
			if isvector(data)
				obj.Gamma.setDataPolarEq(data);
			end
			% Kartesische Koordinaten als nx2 Vektor
			if ismatrix(data) && size(data, 2) == 2
				obj.Gamma.setData(data);
			end
		end

		function setFValue (obj, data)
			% Funktion als symbolischer Ausdruck
			if ischar(data)
				obj.phys.feature(obj.C.name).set('r', data);
			end
			% Interpolation von Datentripel (x, y, f(x,y)) als n×3 Matrix
			if ismatrix(data) && size(data, 2) == 3
				dlmwrite('fData.mat', data, 'delimiter', ' ', 'precision', '%10.6g');

				f = obj.model.func.create('f', 'Interpolation');
				f.set('source', 'file');
				f.set('filename', 'fData.mat');
				f.set('nargs', 2);
				f.set('interp', 'linear');
				%f.set('interp', 'neighbor');

				obj.phys.feature(strcat(obj.C.name, '_dirichlet')).set('r', 'f(x,y)');
			end
			% TODO: Funktion als Interpolation von (f(φ)) mit φ äquidistant.
			% Erfordert Schnitt mit Kurve, schwierig
		end

		function getGValue (obj, dataPoints)
			%mphinterp()
		end

		function initPlot (obj)
			obj.pg1 = obj.model.result.create('pg1', 2);
			obj.pg1.feature.create('surf1', 'Surface');
		end

		function buildGeometry (obj)
			fprintf('Building Geometry ... ');
			obj.geom.run();
			fprintf('finished.\n');
		end

		function initMesh (obj, rf)
			if nargin == 1
				rf = '5';
			else
				rf = int2str(rf);
			end
			obj.mesh = obj.model.mesh.create('mesh', obj.geom_name);
			obj.mesh.feature.create('ftri1', 'FreeTri');
			obj.mesh.feature('size').set('hauto', rf); % Gitterauflösung: 1-9 (fine - coarse)
		end

		function buildMesh (obj)
			% Make sure mesh is initialized
			if ~isa(obj.mesh, 'com.comsol.model.impl.MeshSequenceImpl')
				obj.initMesh();
			end
			fprintf('Building Mesh ... ');
			obj.mesh.run();
			fprintf('finished.\n');
		end

		function initStudy (obj)
			obj.study = obj.model.study.create('std1');
			obj.study.feature.create('st1', 'Stationary');
		end

		function runStudy (obj)
			% Make sure study is initialized
			if ~isa(obj.study, 'com.comsol.model.impl.StudyImpl')
				obj.initStudy();
			end
			fprintf('Running Study ... ');
			obj.study.run();
			fprintf('finished.\n');
		end

		function run (obj)

            meshAndCompute(obj);

            makePlot(obj);

		end
	end
end
