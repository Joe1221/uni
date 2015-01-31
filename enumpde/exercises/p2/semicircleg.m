function [x, y] = semicircleg(bs, s)
	r = 1;

	d = [
		0    , -r ;
		r*pi , r  ;
		1    , 1  ;
		0    , 0  ;
	];

	if nargin == 0; x = 2;        return; end
	if nargin == 1; x = d(:, bs); return; end

	[x, y] = deal(zeros(size(s)));

	m = (bs == 2);
	[x(m), y(m)] = deal(r .* s(m), 0);

	m = (bs == 1);
	[x(m), y(m)] = deal(r .* cos(s(m)), r .* sin(s(m)));
end
