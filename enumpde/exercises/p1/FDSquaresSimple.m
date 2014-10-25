classdef FDSquaresSimple < handle
	properties
		imap % vector of n nodes as structs
		xmap
		ymap
		f % right hand side of pde
		g % dirichlet boundary condition

		h % grid spacing

		A
		b
		u % solution
		fd
	end
	methods
		function obj = FDSquaresSimple(f, g)
			% FDSquaresSimple initializes
			obj.f = f;
			obj.g = g;
			obj.fd = [ ...
				struct('shift', [0,0], 'value', -4); ...
				struct('shift', [1,0], 'value', 1); ...
				struct('shift', [0,1], 'value', 1); ...
				struct('shift', [-1,0], 'value', 1); ...
				struct('shift', [0,-1], 'value', 1); ...
			];
		end

		function init (obj, h)
			% initGrid builds the grid and generates A, b
			%   divides the area in pieces of h×h

			% normalize input value
			n = round(1 / h);
			obj.h = 1 / n;

			clear obj.A obj.b obj.u obj.imap;

			[X, Y] = ndgrid(0:obj.h:3, 0:obj.h:3);


			len1 = (2*n+1)*n;
			len2 = (3*n+1)*(n+1);
			len3 = (2*n+1)*n;

			obj.xmap = [ ...
				reshape(X(1:2*n+1, 1:n), [len1, 1]); ...
				reshape(X(1:3*n+1, n+1:2*n+1), [len2, 1]); ...
				reshape(X(n+1:3*n+1, 2*n+2:3*n+1), [len3, 1]); ...
			];
			obj.ymap = [ ...
				reshape(Y(1:2*n+1, 1:n), [len1, 1]); ...
				reshape(Y(1:3*n+1, n+1:2*n+1), [len2, 1]); ...
				reshape(Y(n+1:3*n+1, 2*n+2:3*n+1), [len3, 1]); ...
			];

			ng = (2*n+1)*n + (3*n+1)*(n+1) + (2*n+1)*n;

			obj.imap(1:2*n+1, 1:n) = reshape(1 : len1, [2*n+1, n]);
			obj.imap(1:3*n+1, n+1:2*n+1) = reshape(len1 + 1 : len1 + len2, [3*n+1, n+1]);
			obj.imap(n+1:3*n+1, 2*n+2:3*n+1) = reshape(len1 + len2 + 1 : len1 + len2 + len3, [2*n+1, n]);

			boundary = [ ...
				reshape(obj.imap(1:2*n+1     , 1)     , [] , 1); ... % horz bot
				reshape(obj.imap(2*n+1:3*n+1 , n+1)   , [] , 1); ... % horz 1/3
				reshape(obj.imap(1:n+1       , 2*n+1) , [] , 1); ... % horz 2/3
				reshape(obj.imap(n+1:3*n+1   , 3*n+1) , [] , 1); ... % horz top

				reshape(obj.imap(1     , 2:2*n)     , [] , 1); ... % vert left
				reshape(obj.imap(n+1   , 2*n+2:3*n) , [] , 1); ... % vert 1/3
				reshape(obj.imap(2*n+1 , 2:n)       , [] , 1); ... % vert 2/3
				reshape(obj.imap(3*n+1 , n+2:3*n)   , [] , 1); ... % vert right
			];

			% FD matrix A construction
			obj.A = sparse(ng, ng);

			mask = obj.imap & ~ismember(obj.imap, boundary);
			% apply FD parts
			for i = 1:numel(obj.fd)
				imap_shift = circshift(obj.imap, obj.fd(i).shift);
				obj.A = obj.A + sparse(obj.imap(mask), imap_shift(mask), obj.fd(i).value, ng, ng);
			end
			obj.A = -obj.A ./ obj.h^2;

			obj.A = obj.A + sparse(boundary, boundary, 1, ng, ng);

			% FD vector b construction
			obj.b = obj.f(obj.xmap,obj.ymap); % b = f
			obj.b(boundary) = obj.g(obj.xmap(boundary),obj.ymap(boundary)); % b = g on boundary

		end

		function solve (obj)
			% solving is the current bottleneck
			obj.u = obj.A \ obj.b;
		end

		function h = plot (obj)
			% construct meshgrid matrices
			n = round(1 / obj.h);

			[X,Y] = meshgrid(0:obj.h:3);
			mask = logical(obj.imap);
			up = zeros(3*n+1);
			up(mask) = obj.u(obj.imap(mask));

			clf;
			h = surf(X,Y,up'); % surf swaps x,y ?
			xlabel('x_1');
			ylabel('x_2');

		end

	end
end
