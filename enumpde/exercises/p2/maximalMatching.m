function ei = maximalMatching(e)
	% Compute a maximal matching for the graph
	%
	% e is a 2×m matrix, describing a list of edges
	% returns edge indices.

	es = false(size(e));
	for i = 1:size(e,2)
		if ~ismember(e(1,i), e(es~=0)) && ~ismember(e(2,i), e(es~=0))
			es(:,i) = true(2,1);
		end
	end
	ei = find(es(1,:));
end
