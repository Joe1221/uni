classdef InverseModel < handle
	% Interface to solve the inverse problem in various ways
	%
	% After initializing the outer boundary C, Neumann data on C and
	% measurement points on C the map function F can be called.
	% The map expects the inner boundary Γ and provides solution data u at the
	% earlier specified measurement points.
	% The function dF provides the jacobian of F.

	properties
		fmodel; % forward model
		dfmodel; % model for computing the jacobian

		outer_boundary;
		inner_boundary;
		dirichlet_data;
		neumann_data;

		it; % Function iteration object

		current_algorithm;
		current_algorithm_desc;

		neumann_inner;

		svg_filename = 'slides/%s_it_%03d.svg'; % 1: Algorithm, 2: Iteration number
		xtol = 1e-3;
	end

	methods
		function obj = InverseModel(outer_boundary, dirichlet_data, neumann_data, inner_boundary)
			% Class constructor

			obj.outer_boundary = outer_boundary;
			obj.inner_boundary = inner_boundary;
			obj.dirichlet_data = dirichlet_data;
			obj.neumann_data = neumann_data;

			obj.it = FunctionIteration(size(inner_boundary, 1), size(dirichlet_data, 1));

			% Initializing forward model
			obj.fmodel = ForwardModel();
			obj.fmodel.setOuterBoundary(obj.outer_boundary);
			obj.fmodel.setInnerBoundary(obj.inner_boundary);
			obj.fmodel.buildGeometry();
			obj.fmodel.buildMesh();
		end

		function [uValues] = F (obj, inner_boundary)
			% Map function
			%
			% Provide the inner boundary as n×2 point matrix and get wonderful
			% solution values at your dirichlet data points.

			fprintf('F-Function called!\n');

			obj.fmodel.setDirichletInnerData('0'); % u = 0 on Γ
			obj.fmodel.setNeumannOuterData(obj.neumann_data);

			obj.fmodel.setInnerBoundary(inner_boundary);
			obj.fmodel.buildGeometry();
			obj.fmodel.buildMesh();
			obj.fmodel.runStudy();
			data = obj.fmodel.getDirichletData( obj.dirichlet_data(:, 1:2) );
			uValues = data(:, 3);
		end

		function [u, Du] = FWithJacobian (obj, inner_boundary)

			fprintf('FWithJacobian-Function called!\n');

			u = obj.F(inner_boundary);

			n = numel(inner_boundary);
			m = size(obj.dirichlet_data, 1);
			H = eye(n); % all directions to search for (standard base)
			Du = zeros(m, n); % Jacobian m×n matrix

			if nargout == 1
				return;
			end

			if ismatrix(inner_boundary) && size(inner_boundary, 2) == 3
				inner_boundary_points = obj.inner_boundary;
			elseif ismatrix(inner_boundary) && size(inner_boundary, 2) == 1
				inner_boundary_points = obj.eqd_radii_to_points(obj.inner_boundary);
			end
			obj.neumann_inner = obj.fmodel.getNeumannData( inner_boundary_points );

			for k = 1:n
				h = H(:,k); % k-th standard base column vector
				Du(:,k) = obj.dF_directional(h); % construct columns of jacobian
			end
		end

		function [dirFData] = dF_directional (obj, direction)
			new_inner_boundary = obj.inner_boundary + direction;

			if ismatrix(new_inner_boundary) && size(new_inner_boundary, 2) == 3
				inner_boundary_points = obj.inner_boundary;
				new_inner_boundary_points = obj.new_inner_boundary;
			elseif ismatrix(new_inner_boundary) && size(new_inner_boundary, 2) == 1
				inner_boundary_points = obj.eqd_radii_to_points(obj.inner_boundary);
				new_inner_boundary_points = obj.eqd_radii_to_points(new_inner_boundary);
			end

			direction_cartesian = new_inner_boundary_points - inner_boundary_points;
			obj.fmodel.setInterpolationFunction('gamma_delta_x', [inner_boundary_points, direction_cartesian(:, 1)] );
			obj.fmodel.setInterpolationFunction('gamma_delta_y', [inner_boundary_points, direction_cartesian(:, 2)] );

			%neumann_inner = obj.fmodel.getNeumannData( inner_boundary_points )
			neumann_inner= obj.neumann_inner;
			if isempty(neumann_inner)
				obj.F(obj.inner_boundary);
				neumann_inner = obj.fmodel.getNeumannData( inner_boundary_points );
			end

			obj.fmodel.setInterpolationFunction('du_inner', neumann_inner);

			obj.fmodel.setDirichletInnerData( ...
				'du_inner(x,y) * (-1) * (gamma_delta_x(x,y) * nx + gamma_delta_y(x,y) * ny)');
			obj.fmodel.setNeumannOuterData('0');

			obj.fmodel.runStudy();

			data = obj.fmodel.getDirichletData( obj.dirichlet_data(:, 1:2) );
			dirFData = data(:, 3);

		end

		function plot (obj, plot_title)
			% Plot current outer and inner curve

			fh = gcf();
			axh = gca();

			obj.fmodel.makePlot();

			% Hide colored areas (curves remain)
			set(findobj(fh, 'FaceColor', 'interp'), 'Visible', 'off')

			if nargin == 1
				plot_title = sprintf('%s - Iteration %d', obj.current_algorithm_desc, obj.it.k - 1);
			end
			title(axh, plot_title);

			axis tight;
			axis(axis() + [-0.1, 0.1, -0.1, 0.1]);
			set(axh, 'LineWidth', 0.1);
			set(get(axh, 'xlabel'), 'FontSize', 6);
			set(get(axh, 'ylabel'), 'FontSize', 6);
			set(get(axh, 'title'), 'FontSize', 10);

			grid on;

		end

		function clearSvgs (obj)
			if isempty(obj.current_algorithm)
				return
			end

			delete(sprintf('%s_it_%s.svg', obj.current_algorithm, '*'));
		end

		function saveSvg (obj, filename)

			if nargin == 1
				filename = sprintf(obj.svg_filename, obj.current_algorithm, obj.it.k - 1);
			end

			%obj.plot();

			addpath slides/plot2svg

			plot2svg(filename, gcf());

			rmpath slides/plot2svg

		end

		function stop = outfun (obj, x, opt_data, state)
			stop = false;
			switch state
				case 'iter'
					obj.it.addIterate(x, opt_data.fval);
					opt_data.iteration
					x
					norm(opt_data.fval)
					obj.plot();
					drawnow;
					obj.saveSvg();
					%stop = true;
				otherwise
			end
		end

		function solveLevenbergMarquardtFD (obj)
			obj.current_algorithm = 'levmarq_fd';
			obj.current_algorithm_desc = 'Levenberg-Marquardt (FD)';
			obj.clearSvgs();
			obj.it.reset();

			options = optimoptions(@fsolve, ...
					'Algorithm', 'levenberg-marquardt', ...
					'OutputFcn', @obj.outfun, ...
					'Diagnostics', 'on', ...
					'TolFun', 1e-4, ...
					'TolX', obj.xtol ...
				);
			fsolve( ...
					@(x) obj.F(x) - obj.dirichlet_data(:, 3), ...
					obj.inner_boundary, ...
					options ...
				);
		end


		function [u, Du] = HWithJacobian (obj, gamma)
			if nargout == 1
				u = obj.FWithJacobian(gamma);
			else
				[u, Du] = obj.FWithJacobian(gamma);
			end
			u = u - obj.dirichlet_data(:, 3);
		end

		function solveLevenbergMarquardt (obj)
			obj.current_algorithm = 'levmarq';
			obj.current_algorithm_desc = 'Levenberg-Marquardt';
			obj.clearSvgs();
			obj.it.reset();

			options = optimoptions(@fsolve, ...
					'Algorithm', 'levenberg-marquardt', ...
					'OutputFcn', @obj.outfun, ...
					'Jacobian', 'on', ...
					'Diagnostics', 'on', ...
					'TolFun', 1e-4, ...
					'TolX', obj.xtol ...
				);
			fsolve( ...
					@obj.HWithJacobian, ...
					obj.inner_boundary, ...
					options ...
				);
		end

		function solveGaussNewton (obj)
			obj.current_algorithm = 'gsnewt';
			obj.current_algorithm_desc = 'Gauß-Newton';
			obj.clearSvgs();
			obj.it.reset();

			x0 = obj.inner_boundary;
			x = x0;

			[f, Df] = obj.HWithJacobian(x);
			obj.it.addIterate(x, f);

			obj.plot()
			drawnow;
			obj.saveSvg();

			d = - (Df' * Df) \ (Df' * f);
			while (norm(d) > obj.xtol)
				x = x + d;

				[f, Df] = obj.HWithJacobian(x);
				obj.it.addIterate(x, f);

				obj.plot()
				drawnow;
				obj.saveSvg();

				d = - (Df' * Df) \ (Df' * f);
			end
		end
	end
	methods (Static)
		M = eqd_radii_to_points(r);
	end
end
