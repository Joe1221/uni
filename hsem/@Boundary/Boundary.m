classdef Boundary < handle
	properties
		geom; % comsol geometry object
		name; % name of curve
		gref; % reference to comsol curve object
	end
	methods
		function obj = Boundary(geom, name, data)
			obj.geom = geom;
			obj.name = name;

			obj.gref = obj.geom.feature.create(obj.name, 'InterpolationCurve');

			obj.gref.set('type', 'closed');

			% Polarkoordinaten als Radien-Vektor
			if nargin == 3 && isvector(data)
				obj.setDataPolarEq(data);
			end
			% Kartesische Koordinaten als n×2 Vektor
			if nargin == 3 && ismatrix(data) && size(data, 2) == 2
				obj.setData(data);
			end
		end
		% Polarkoordinaten als Radien-Vektor
		function setDataPolarEq (obj, radii)
			obj.setData(obj.convertCurve(radii));
		end
		% Kartesische Koordinaten als n×2 Vektor
		function setData (obj, data)
			obj.gref.set('table', data);
		end
	end
	methods (Static)
		M = convertCurve(r);
	end
end
