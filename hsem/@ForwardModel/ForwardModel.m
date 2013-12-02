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

		% �u�eres / Omega und C
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
			% TODO: Funktion als Interpolation von Messdaten
		end

		function run (obj)
			
            meshAndCompute(obj);
            
            makePlot(obj);

		end
	end
end
