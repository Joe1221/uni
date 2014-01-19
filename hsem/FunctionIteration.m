classdef FunctionIteration < handle
	% FunctionIteration Keep track of your function iterates!
	properties
		n;     % Dimension of function domain
		m;     % Dimension of function codomain
		k;     % Number of iterates (up until now)
		X;     % Array of iterates
		F;     % Array of function iterates
	end
	methods
		function obj = FunctionIteration (dim_domain, dim_codomain)
			obj.n = dim_domain;
			if nargin == 1
				obj.m = 1;
			else
				obj.m = dim_codomain;
			end

			obj.reset();
		end
		function addIterate (obj, x, fx)
			% TODO: improve performance by preallocating amounts of powers of two
			obj.X(obj.k + 1, :) = x;
			obj.F(obj.k + 1, :) = fx;

			obj.k = obj.k + 1;
		end
		function reset (obj)
			obj.X = zeros(1, obj.n);
			obj.F = zeros(1, obj.m);
			obj.k = 0;
		end
	end
end


