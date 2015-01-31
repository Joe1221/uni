function [p, e, t] = bisect2 (g, p, e, t, k)
	function [tc, peo] = getConjTriangles (pe, t)
		% find triangle indices
		[~, i] = ismember(pe', t([1,3],:)', 'rows');
		[~, j] = ismember(pe', t([2,1],:)', 'rows');
		[~, l] = ismember(pe', t([3,2],:)', 'rows');
		tc = (i + j + l)';
		% get conjugate triangles' opposite points
		peo(i ~= 0) = t(2, i(i ~= 0));
		peo(j ~= 0) = t(3, j(j ~= 0));
		peo(l ~= 0) = t(1, l(l ~= 0));
	end
	function [pe, po1, po2, tc] = getLongestEdge (p, t, k)
		tkp = t(1:3, k); % selected triangles points indices
		% extract point coordinates
		tkpc = p(sub2ind(size(p), repmat(permute([1 2], [1 3 2]), [size(tkp) 1]), repmat(tkp, [1 1 2])));
		% max edge length
		[~, i] = max(sum((tkpc - circshift(tkpc, -1, 1)) .^ 2, 3), [], 1);
		j = mod(i, 3) + 1;
		% longest-edge point indices (each column is subset of corresponding column in tkp)
		pe = tkp(sub2ind(size(tkp), [i; j], repmat(1:size(tkp, 2), [2 1])));
		% longest-edge opposing points
		po1 = tkp(sub2ind(size(tkp), mod(j, 3) + 1, 1:size(tkp, 2)));
		[tc, po2] = getConjTriangles(pe, t);
	end

	g = str2func(g);
	k = unique(k);

	k1 = k;
	[~, ~, ~, k2] = getLongestEdge(p, t, k1);
	[~, ~, ~, k3_] = getLongestEdge(p, t, k2(k2~=0));
	%fprintf('bisecting triangles:')
	k3 = zeros(size(k1));
	k3(k2 ~= 0) = k3_;
	[k1; k2; k3];

	tmp = unique(k1(k2 == 0));
	tmp2 = k1(k1 == k3);

	k1 = [tmp, tmp2];
	[~, ~, ~, k2] = getLongestEdge(p, t, k1);

	% cleanup
	%[~, ku] = unique(k2);
	%k1 = setdiff([k1(ku'), k1(k2==0)], k2);
	%%


	k;

	k2(k2 == 0) = length(k) + (1:length(k2) - nnz(k2));
	[k1; k2];
	k1 = k1(maximalMatching([k1; k2]));


	[pe, po1, po2, k2] = getLongestEdge(p, t, k1);

	%fprintf('bisecting triangles (cleaned):')
	%[k1; k2]



	[pbn, pin] = deal(zeros(2,0));
	ebn = zeros(7,0);
	[tbn, tin] = deal(zeros(4,0));

	% process boundary edges

	% find boundary-edges between the point-pairs
	[~, i] = ismember(pe', e([1, 2],:)', 'rows');
	[~, j] = ismember(pe', e([2, 1],:)', 'rows');
	i = (i + j)';
	ec = e(:, i(i ~= 0)); % edges to bisect
	bm = k2 == 0;

	%fprintf('bisecting triangles with outer edges:')
	%k1(bm)
	if numel(ec)
		ebns = (ec(3,:) + ec(4,:)) / 2; % new parameter values
		ebnp = size(p, 2) + (1:size(ec, 2)); % new point indices
		[x, y] = g(ec(5,:), ebns);

		pbn = [x; y]; % new points
		ebn = [ ...
			[ec(1,:); ebnp; ec(3,:); ebns; ec(5:7,:)], ...
			[ebnp; ec(2,:); ebns; ec(4,:); ec(5:7,:)] ...
		];
		tbn = [ ...
			[ec(1,:); ebnp; po1(bm); t(4, k1(bm))], ...
			[ebnp; ec(2,:); po1(bm); t(4, k1(bm))], ...
		];
	end

	% process inner edges
	im = k2 ~= 0;
	pc = pe(:, find(im));
	%fprintf('bisecting triangles with inner edges:')
	%k1(im)
	if numel(pc)
		pin = permute(sum(p(sub2ind(size(p), repmat(permute([1 2], [1 3 2]), [size(pc) 1]), repmat(pc, [1 1 2]))), 1) / 2, [3 2 1]);
		pini = size(p, 2) + size(pbn, 2) + (1:size(pc, 2)); % new point indices
		tin = [ ...
			[pc(1,:); pini; po1(im); t(4, k1(im))], ...
			[pini; pc(2,:); po1(im); t(4, k1(im))], ...
			[pc(1,:); po2(im); pini; t(4, k2(im))], ...
			[pc(2,:); pini; po2(im); t(4, k2(im))], ...
		];
	end
	%a(-1)

	% remove old triangles and boundary-edges
	t(:,[k1, k2(k2 ~= 0)]) = [];
	e(:,i(i~=0)) = [];

	% add new entities
	p = [p, pbn, pin];
	e = [e, ebn];
	t = [t, tbn, tin];

end
