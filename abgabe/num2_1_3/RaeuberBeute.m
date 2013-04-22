function [y1, y2] = RaeuberBeute(T, h, y0, r, f)
	% Initialisiere mit Startwert
	y1(1) = y0(1);
	y2(1) = y0(2);

	% Iteriere über die Unterteilung
	for i = 1:T/h
		% Entwicklungsschritt
		y1(i+1) = y1(i) + h * (r(1)*y1(i) - f(1)*y1(i)*y2(i));
		y2(i+1) = y2(i) + h * (-r(2)*y2(i) + f(2)*y1(i)*y2(i));
	end
end
