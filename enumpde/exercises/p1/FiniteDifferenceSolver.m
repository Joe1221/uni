classdef (Abstract) FiniteDifferenceSolver < handle
	properties
		mask
		pos2idxMap
		idx2posMap
		n % = numel(pos2idxMap)
		h

		A
		b
		u
	end
	methods (Abstract)
		buildGrid(obj, h)
	end
	methods
		function solve (obj)
			obj.u = obj.A \ obj.b;
		end
		function A = applyFD (obj, indexMask, fdStar)

			A = sparse(obj.n, obj.n);

			for i = fdStar.entries
				pos2idxMap_shifted = circshift(obj.pos2idxMap, fdStar(i).shift);

				A = A + sparse( ...
					obj.pos2idxMap(indexMask), ...
					pos2idxMap_shifted(indexMask), ...
					fdStar(i).value, ...
					obj.n, obj.n ...
				);
			end
		end
	end
end
