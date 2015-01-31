function mypdeplot (p, e, t)
	clf
	[x, y] = deal(p(1,:), p(2,:));

	patch( x(t(1:3, :)), y(t(1:3, :)), 'w', 'EdgeColor', [0 0 1] );

	% attach labels to triangles
	%[cx, cy] = deal(sum(x(t(1:3, :)), 1) / 3, sum(y(t(1:3, :)), 1) / 3);
	%tlabels = num2cell(1:size(t,2));
	%text(cx, cy, tlabels);

	line(  x(e(1:2, :)), y(e(1:2, :)), 'Color', [1 0 0] );
end
