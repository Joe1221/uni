classdef ObjectiveFunction < handle
	% This class wraps a boundary-to-function map
	%
	% After initializing the outer boundary C, Neumann data on C and
	% measurement points on C the map function F can be called.
	% The map expects the inner boundary Γ and provides solution data u at the
	% earlier specified measurement points.
	% The function dF provides the jacobian of F.

	properties
		fmodel; % forward model
		dfmodel; % model for computing the jacobian
		measurement_points; % point data for measurements

		old_inner_boundary;
	end

	methods
		function obj = ObjectiveFunction(outer_boundary, outer_neumann_data, measurement_points)
			% Class constructor

			obj.measurement_points = measurement_points;

			% Initializing forward model
			obj.fmodel = ForwardModel();
			obj.fmodel.setOuterBoundary(outer_boundary);
			obj.fmodel.setDirichletInnerData('0'); % u = 0 on Γ
			obj.fmodel.setNeumannOuterData(outer_neumann_data);

			% Initializing jacobian model
			%obj.dfmodel = ForwardModel();
			%obj.dfmodel.setOuterBoundary(outer_boundary);
			%obj.dfmodel.setNeumannInnerData('0'); % u = 0 on Γ
		end

		function [uValues] = F (obj, inner_boundary)
			% Map function
			%
			% Provide the inner boundary as n×2 point matrix and get wonderful
			% solution values at your specified measurement points.

			obj.fmodel.setInnerBoundary(inner_boundary);
			obj.fmodel.buildGeometry();
			obj.fmodel.buildMesh();
			obj.fmodel.runStudy();
			data = obj.fmodel.getDirichletData(obj.measurement_points);
			uValues = data(:,3);

			if (isempty(obj.old_inner_boundary))
				obj.old_inner_boundary = inner_boundary;
			end
			if norm(obj.old_inner_boundary - inner_boundary) > 1e-6
				obj.fmodel.makePlot();
			end

			obj.old_inner_boundary = inner_boundary;
		end

		function [jacobian] = dF (obj, inner_boundary)
			% Jacobian derivative of the map function
			%
			% The jacobian is an m×n matrix, where n is the number of variables
			% specifying the inner boundary and m is the number of
			% measurements.

			% first we need neumann-data on gamma



			n = numel(inner_boundary);
			H = eye(N); % all directions to search for (standard base)

			obj.dfmodel.setInnerBoundary(inner_boundary);
			obj.dfmodel.buildGeometry();
			obj.dfmodel.buildMesh();

			obj.dfmodel.setDirichletOuterData('');

			for i = 1:n
				h = H(:,i); % i-th standard base column vector

			end
		end
	end
end
