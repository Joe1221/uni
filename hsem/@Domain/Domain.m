classdef Domain < handle
	% Domain Gebiet
	% Abstraktion eines Gebiets.

	properties
		geom; % comsol geometry object
		name; % name of curve
		gref; % reference to comsol curve object
	end
	methods
		function obj = Domain (geom, name, data, data2)
			obj.geom = geom;
			obj.name = name;

			% Erstelle Gebiet aus einer Randkurve
			if nargin == 3 && isa(data, 'Boundary')
				obj.gref = obj.geom.feature.create(obj.name, 'ConvertToSolid');
				obj.gref.selection('input').set({data.name});
				obj.gref.set('createselection', 'on');
			end
			% Erstelle Gebiet als Differenz zweier Gebiete
			if nargin == 4
				% Ziehe D von Omega ab, damit das Innere von D am Ende nicht als selection auftritt
				obj.gref = obj.geom.feature.create(obj.name, 'Difference');
				obj.gref.selection('input').set({data.name});
				obj.gref.selection('input2').set({data2.name});
				obj.gref.set('createselection', 'on');
			end
		end
	end

end
