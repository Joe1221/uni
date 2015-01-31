function [x, y] = sectorg(bs, s)
	r = 1;
	alpha = 5/3*pi;

	d = [
		0 , 0       , r ;
		r , alpha*r , 0 ;
		1 , 1       , 1 ;
		0 , 0       , 0 ;
	];

	if nargin == 0; x = 3;        return; end
	if nargin == 1; x = d(:, bs); return; end

	[x, y] = deal(zeros(size(s)));
	[lm, rm] = deal(bs == 1, bs == 3);

	[x(lm), y(lm)] = deal(r         , 0         );
	[x(rm), y(rm)] = deal(cos(alpha), sin(alpha));

	m = (lm | rm);
	[x(m), y(m)] = deal(x(m) .* s(m), y(m) .* s(m));

	m = (bs == 2);
	[x(m), y(m)] = deal(r .* cos(s(m)), r .* sin(s(m)));
end
