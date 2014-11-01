classdef FDSquaresSimple < FiniteDifferenceSolver
	properties
		f % right hand side of pde
		g % dirichlet boundary condition

		m

		%mask
		innerMask
		boundaryMask

		posX
		posY

		%idx2posMap
		%pos2idxMap

		innerIdx
		boundaryIdx
	end
	methods
		function obj = FDSquaresSimple(f, g)
			obj.f = f;
			obj.g = g;
		end

		function initialize (obj, h)
			clear obj.A  obj.b  obj.u  obj.innerIdx  obj.boundaryIdx  obj.idx2posMap  obj.pos2idxMap  obj.posX  obj.posY  obj.innerMask  obj.boundaryMask;
			obj.buildGrid(h);
			obj.assemble();
		end

		function buildGrid (obj, h)

			nh = round(1 / h); % discrete block size
			obj.h = 1 / nh; % normalized spacing
			obj.m = 3 * nh + 1; % total discrete width/height

			% dirty domain construction
			[obj.mask, obj.innerMask] = deal(false(obj.m, obj.m));
			obj.mask      ( 1    : 2*nh+1  , 1    : 2*nh+1)  = true;
			obj.mask      ( nh+1 : obj.m   , nh+1 : obj.m)   = true;
			obj.innerMask ( 2    : 2*nh    , 2    : 2*nh)    = true;
			obj.innerMask ( nh+2 : obj.m-1 , nh+2 : obj.m-1) = true;
			obj.boundaryMask = obj.mask & ~obj.innerMask;
			obj.n = nnz(obj.mask);

			% positioning
			[obj.posX, obj.posY] = ndgrid(0:obj.h:3, 0:obj.h:3);

			% numeration according to indices in find(…)
			obj.idx2posMap = find(obj.mask);
			obj.pos2idxMap = zeros(obj.m, obj.m);
			obj.pos2idxMap(obj.idx2posMap) = 1:numel(obj.idx2posMap);

			% indices
			obj.boundaryIdx = obj.pos2idxMap(obj.boundaryMask);
			obj.innerIdx = obj.pos2idxMap(obj.innerMask);
		end

		function assemble (obj)
			% FD matrix A construction
			obj.A = sparse(obj.n, obj.n);
			obj.b = zeros(obj.n, 1);

			% Interior conditions
			fdStar = FDStar([0, -1, 0; -1, 4, -1; 0, -1, 0] ./ obj.h^2);
			obj.A = obj.applyFD(obj.innerMask, fdStar);
			% b = f on interior
			obj.b(obj.innerIdx) = obj.f( ...
				obj.posX(obj.idx2posMap(obj.innerIdx)), ...
				obj.posY(obj.idx2posMap(obj.innerIdx)) ...
			);

			% boundary conditions
			obj.A = obj.A + sparse(obj.boundaryIdx, obj.boundaryIdx, 1, obj.n, obj.n);
			% b = g on boundary
			obj.b(obj.boundaryIdx) = obj.g( ...
				obj.posX(obj.idx2posMap(obj.boundaryIdx)), ...
				obj.posY(obj.idx2posMap(obj.boundaryIdx)) ...
			);
		end

		function h = plot (obj)

			% construct meshgrid matrix
			F = zeros(obj.m);
			F(obj.mask) = obj.u(obj.pos2idxMap(obj.mask));

			%clf;
			h = surf(obj.posX, obj.posY, F'); % surf swaps x,y ?
			xlabel('x_1');
			ylabel('x_2');
		end

		function err = computeError (obj, solution)
			err = max(solution(obj.posX(obj.mask), obj.posY(obj.mask)) - obj.u);
		end

	end
end
