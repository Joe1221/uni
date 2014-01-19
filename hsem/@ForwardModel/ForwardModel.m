classdef ForwardModel < handle
	% ForwardModel Klasse zum Lösen des Vorwärtsproblems
	% Diese Klasse kümmert sich um das Erstellen eines Comsol Modells, die
	% Erstellung einer 2D-Geometrie und abstrahiert das Definieren der
	% nötigen Randkurven/Gebiete für das Vorwärtsproblem der Gebietserkennung.

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
		gDataSet;
		gEval;
		pointEval;
		pointDataSet;
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

		function initPointEval (obj)
			if ~isa(obj.pointEval, 'com.comsol.model.impl.NumericalFeatureImpl')
				if ~isa(obj.pointDataSet, 'com.comsol.model.impl.DatasetFeatureImpl')
					obj.pointDataSet = obj.model.result.dataset.create('cutpoint', 'CutPoint2D');
				end
				obj.pointEval = obj.model.result.numerical.create('evalpoint', 'EvalPoint');
				obj.pointEval.set('data', 'cutpoint'); % select obj.gDataSet as points to evaluate at
			end
		end

		function setInterpolationFunction (obj, name, data)
			% setup an interpolation function for the given data
			%
			% currently only n×3 matrix data in the form (x, y, f(x,y)) is accepted

			try
				func = obj.model.func(name);
			catch
				func = obj.model.func.create(name, 'Interpolation');
			end

			% Interpolation von Datentripel (x, y, f(x,y)) als n×3 Matrix
			if ismatrix(data) && size(data, 2) == 3
				tmpfile = strcat('intep_data_', name, '.mat');
				dlmwrite(tmpfile, data, 'delimiter', ' ', 'precision', '%10.6g');

				func.set('source', 'file');
				func.set('filename', tmpfile);
				func.set('nargs', 2);
				func.set('interp', 'linear');
				%f.set('interp', 'neighbor');
			end
		end


		% TODO: folgende Funktionen in eigene Dateien

		% Äußeres / Omega und C
		function setOuterBoundary (obj, data)
			% Specifies the outer boundary curve C
			%     It can be given as a vector of polar radii which get placed at
			%     equidistant angles, or as a n×2 matrix consisting of points in
			%     cartesian coordinates.

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
			% Specifies the inner boundary curve Γ
			%     It can be given as a vector of polar radii which get placed at
			%     equidistant angles, or as a n×2 matrix consisting of points in
			%     cartesian coordinates.

			% Polarkoordinaten als Radien-Vektor
			if isvector(data)
				obj.Gamma.setDataPolarEq(data);
			end
			% Kartesische Koordinaten als nx2 Vektor
			if ismatrix(data) && size(data, 2) == 2
				obj.Gamma.setData(data);
			end
		end

		function setDirichletInnerData (obj, data)
			% Specifies Dirichlet data on the inner curve Γ
			%     data should contain a string expression

			if ischar(data)
				obj.phys.feature(strcat(obj.Gamma.name, '_dirichlet')).set('r', data);
			end
			obj.phys.feature(strcat(obj.Gamma.name, '_dirichlet')).active(true);
			obj.phys.feature(strcat(obj.Gamma.name, '_neumann')).active(false);
		end

		function setDirichletOuterData (obj, data)
			% Specifies Dirichlet data on the outer curve C
			%     Hereby it is assumed you are going to compute Neumann data,
			%     thus any values set through setNeumannOuterData are dismissed.
			%     data should contain a string expression or a n×2 matrix
			%     containing cartesian coordinates.

			% Funktion als symbolischer Ausdruck
			if ischar(data)
				obj.phys.feature(strcat(obj.C.name, '_dirichlet')).set('r', data);
			end
			% Interpolation von Datentripel (x, y, f(x,y)) als n×3 Matrix
			if ismatrix(data) && size(data, 2) == 3
				%% We actually interpolate the given data to obtain a function on
				%% the whole domain ...
				obj.setInterpolationFunction('f', data);

				%% ... and then specify this function as dirichlet data
				obj.phys.feature(strcat(obj.C.name, '_dirichlet')).set('r', 'f(x,y)');
			end

			obj.phys.feature(strcat(obj.C.name, '_dirichlet')).active(true);
			obj.phys.feature(strcat(obj.C.name, '_neumann')).active(false);
			% TODO: Funktion als Interpolation von (f(φ)) mit φ äquidistant.
			% Erfordert Schnitt mit Kurve, schwierig
		end

		function setNeumannOuterData (obj, data)
			% Specifies Neumann data on the outer curve C
			%     Hereby it is assumed you are going to compute Dirichlet data,
			%     thus any values set through setDirichletOuterData are dismissed.
			%     data should contain a string expression or a n×2 matrix
			%     containing cartesian coordinates.

			% Funktion als symbolischer Ausdruck
			if ischar(data)
				obj.phys.feature(strcat(obj.C.name, '_neumann')).set('g', data);
			end
			% Interpolation von Datentripel (x, y, f(x,y)) als n×3 Matrix
			if ismatrix(data) && size(data, 2) == 3
				%% We actually interpolate the given data to obtain a function on
				%% the whole domain ...
				obj.setInterpolationFunction('g', data);

				% ... and then specify this function as dirichlet data
				obj.phys.feature(strcat(obj.C.name, '_neumann')).set('g', 'g(x,y)');
			end

			obj.phys.feature(strcat(obj.C.name, '_neumann')).active(true);
			obj.phys.feature(strcat(obj.C.name, '_dirichlet')).active(false);
			% TODO: Funktion als Interpolation von (f(φ)) mit φ äquidistant.
			% Erfordert Schnitt mit Kurve, schwierig
		end

		function setNeumannInnerData (obj, data)
			% Specifies Neumann data on the inner curve Γ
			%     data should contain a string expression or a n×2 matrix
			%     containing cartesian coordinates.

			% Funktion als symbolischer Ausdruck
			if ischar(data)
				obj.phys.feature(strcat(obj.Gamma.name, '_neumann')).set('g', data);
			end
			% Interpolation von Datentripel (x, y, f(x,y)) als n×3 Matrix
			if ismatrix(data) && size(data, 2) == 3
				%% We actually interpolate the given data to obtain a function on
				%% the whole domain ...
				obj.setInterpolationFunction('inner_neumann', data);

				% ... and then specify this function as dirichlet data
				obj.phys.feature(strcat(obj.Gamma.name, '_neumann')).set('g', 'inner_neumann(x,y)');
			end

			obj.phys.feature(strcat(obj.Gamma.name, '_neumann')).active(true);
			obj.phys.feature(strcat(obj.Gamma.name, '_dirichlet')).active(false);
			% TODO: Funktion als Interpolation von (f(φ)) mit φ äquidistant.
			% Erfordert Schnitt mit Kurve, schwierig
		end

		function [data] = getNeumannData (obj, dataPoints)
			% Retrieval of Neumann solution data on the nearest boundary
			%     Neumann data here means the normal derivative du/dν, where ν
			%     is the boundary normal vector pointing outside.
			%     dataPoints should contain a string expression or a n×2 matrix
			%     containing cartesian coordinates.
			%     You should provide points that lie on a boundary or else they
			%     get snapped to the nearest one.

			obj.initPointEval();
			obj.pointDataSet.set('bndsnap', true); % stay on boundary for normal vector
			obj.pointDataSet.set('pointx', dataPoints(:, 1));
			obj.pointDataSet.set('pointy', dataPoints(:, 2));
			obj.pointEval.set('expr', 'ux*nx + uy*ny'); % = du/dν
			gValues = obj.pointEval.getReal();
			obj.pointEval.set('expr', 'x');
			xValues = obj.pointEval.getReal();
			obj.pointEval.set('expr', 'y');
			yValues = obj.pointEval.getReal();
			data = [xValues, yValues, gValues];
		end

		function [boundary_points] = snapToBoundary (obj, points)
			obj.initPointEval();
			obj.pointDataSet.set('bndsnap', true); % stay on boundary for normal vector
			obj.pointDataSet.set('pointx', points(:, 1));
			obj.pointDataSet.set('pointy', points(:, 2));
			obj.pointEval.set('expr', 'x');
			xValues = obj.pointEval.getReal();
			obj.pointEval.set('expr', 'y');
			yValues = obj.pointEval.getReal();
			boundary_points = [xValues, yValues];
		end

		function [data] = getDirichletData (obj, dataPoints)
			% Retrieval of Dirichlet solution data on the nearest boundary
			%     dataPoints should contain a string expression or a n×2 matrix
			%     containing cartesian coordinates.
			%     You should provide points that lie on a boundary or else they
			%     get snapped to the nearest one.

			obj.initPointEval();
			obj.pointDataSet.set('bndsnap', true); % stay on boundary for normal vector
			obj.pointDataSet.set('pointx', dataPoints(:, 1));
			obj.pointDataSet.set('pointy', dataPoints(:, 2));
			obj.pointEval.set('expr', 'u');
			uValues = obj.pointEval.getReal();
			obj.pointEval.set('expr', 'x');
			xValues = obj.pointEval.getReal();
			obj.pointEval.set('expr', 'y');
			yValues = obj.pointEval.getReal();
			data = [xValues, yValues, uValues];
		end

		function initPlot (obj)
			obj.pg1 = obj.model.result.create('pg1', 2);
			obj.pg1.feature.create('surf1', 'Surface');
		end

		function buildGeometry (obj)
			%fprintf('Building Geometry ... ');
			obj.geom.run();
			%fprintf('finished.\n');
		end

		function initMesh (obj, rf)
			if nargin == 1
				rf = '1';
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
			%fprintf('Building Mesh ... ');
			obj.mesh.run();
			%fprintf('finished.\n');
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
