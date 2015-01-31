function [p, e, t] = bisect (g, p, e, t, k)
	function [tc, peo] = getConjTriangles (pe, t)
		% find triangle indices
		[~, i] = ismember(pe', t([1,3],:)', 'rows');
		[~, j] = ismember(pe', t([2,1],:)', 'rows');
		[~, l] = ismember(pe', t([3,2],:)', 'rows');
		tc = (i + j + l)';
		% get conjugate triangles' opposite points
		peo = zeros(1, size(pe, 2));
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

	function removeTriangle (tr)
		t(:, tr) = [];

		% fixme: update indices
		k(k > tr) = k(k > tr) - 1;
		k2(k2 > tr) = k2(k2 > tr) - 1;
		lepp(lepp > tr) = lepp(lepp > tr) - 1;
	end
	function bisectBoundary (t0, e0, o0)
		ed = e(:,e0);
		pni = size(p, 2) + 1;
		ens = (ed(3) + ed(4)) / 2;

		[x, y] = g(ed(5), ens);
		pn = [x; y];
		en = [ ...
			[ed(1); pni; ed(3); ens; ed(5:7)], ...
			[pni; ed(2); ens; ed(4); ed(5:7)], ...
		];
		tn = [ ...
			[o0; ed(1); pni; t(4, t0)], ...
			[o0; pni; ed(2); t(4, t0)], ...
		];
		[p, e, t] = deal([p, pn], [e, en], [t, tn]);

		e(:,e0) = [];
		removeTriangle(t0);
		[Pe, po1, po2, k2] = getLongestEdge(p, t, 1:size(t,2));
	end
	function bisectPair (t1, t2, p1, p2, o1, o2)
		pni = size(p, 2) + 1;

		pn = (p(:, p1) + p(:, p2)) / 2;
		tn = [ ...
			[o1; p1; pni; t(4,t1)], ...
			[o1; pni; p2; t(4,t1)], ...
			[o2; p2; pni; t(4,t2)], ...
			[o2; pni; p1; t(4,t2)], ...
		];
		[p, t] = deal([p, pn], [t, tn]);

		removeTriangle(max(t1, t2));
		removeTriangle(min(t1, t2));
		%[Pe, po1, po2, k2] = getLongestEdge(p, t, size(t,2)-3:size(t,2));
		[Pe, po1, po2, k2] = getLongestEdge(p, t, 1:size(t,2));
	end


	g = str2func(g);
	k = unique(k);

	while ~isempty(k)
		[Pe, po1, po2, k2] = getLongestEdge(p, t, 1:size(t,2));
		%[1:size(t,2); k2]
		%[Pe; po1; po2]

		% compute a longest-edge propagation path (LEPP)
		%fprintf('Refining triangle %d\n', k(1));
		lepp = [k(1)];
		while k2(lepp(end)) ~= 0 && ~ismember(k2(lepp(end)), lepp)
			lepp = [lepp, k2(lepp(end))];
		end
		lepp = flip(lepp);

		% FIXME: what about cycles? They don't matter, think about it!

		while ~isempty(lepp)
			t1 = lepp(1);

			%[1:size(t,2); k2]
			%[Pe; po1; po2]
			%lepp
			%mypdeplot(p,e,t);
			if t1 <= numel(k2) && k2(t1) == 0
				if numel(lepp) > 1
					t2 = lepp(2);
					[~, v] = intersect(Pe(:,t1), Pe(:,t2));
				end

				[~, i] = ismember(Pe(:,t1)', e([1, 2],:)', 'rows');
				[~, j] = ismember(Pe(:,t1)', e([2, 1],:)', 'rows');
				i = (i + j)';
				k = setdiff(k, t1);

				bisectBoundary(t1, i, po1(t1));
				if numel(lepp) > 1
					lepp(1) = size(t, 2) - 2 + v;
				else
					lepp(1) = [];
				end
				%lepp(1) = [];

			elseif numel(lepp) == 2
				%fprintf('Bisecting last Pair\n');
				t2 = lepp(2);
				k = setdiff(k, [t1, t2]);
				lepp = [];

				bisectPair(t2, t1, Pe(1,t2), Pe(2,t2), po1(t2), po2(t2));
			elseif numel(lepp) > 2
				%fprintf('Bisecting middle pair\n');
				[t2, t3] = deal(lepp(2), lepp(3));

				k = setdiff(k, [t1, t2]);

				[~, v] = intersect(Pe(:,t2), Pe(:,t3));

				bisectPair(t2, t1, Pe(1,t2), Pe(2,t2), po1(t2), po2(t2));
				lepp(2) = size(t, 2) - 4 + v;
				lepp(1) = [];
			end
			%p,e,t
			%mypdeplot(p,e,t);
			%pause(0.10);
		end


		%[p, e, t] = bisectLEPP(g, p, e, t, Tc, lepp);
	end
end
