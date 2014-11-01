classdef FDStar < handle
	properties (Access = protected)
		matrix
		dims
	end
	properties
		entries
	end
	methods
		function obj = FDStar (matrix)
			obj.matrix = matrix;
			obj.dims = size(matrix);
			obj.entries = find(matrix).';
		end
		function shift = getShift (obj, index)
			% calc shift from index position
			shift = cell(1, numel(obj.dims));
			[shift{:}] = ind2sub(obj.dims, index);
			shift = cell2mat(shift);
			shift = shift - 1 - ((obj.dims - 1) ./ 2);
		end
		function sref = subsref (obj, S)
			switch S(1).type
			case '()'
				index = S(1).subs{:};
				switch S(2).type
				case '.'
					switch S(2).subs
					case 'value'
						sref = obj.matrix(index);
					case 'shift'
						sref = obj.getShift(index);
					end
				end
			case '.'
				sref = builtin('subsref', obj, S);
			end
		end
	end

end

