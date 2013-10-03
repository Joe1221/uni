% Verena Treitz , Stephan Hilb (2706616), Matthias Hofmann

% Numerik 2 Blatt 8
% Programmieraufgabe 8.3 
% Aufgabenteil e) Testfunktion sowie Plot

function [] = test_e()
	figure(1);
	% Die Funktion sowie Anfangswerte sind von der auf dem Übungsblatt
	% angegebenen Seite übernommen.
	f = @(y) [y(2); 1000*(1 - y(1)^2)*y(2) - y(1)];
	Jf = @(y) [0, 1; -2000*y(1)*y(2) - 1, 1000*(1 - y(1))];


	x0 = 0;
	y0 = [2; 0];
	T = 3000;
	h0 = 20; % war nicht angegeben
	tol = 10^-5;
	tau = 0.9; % wie in A5.3 b) 
	p = 2; % Da bin ich mir nicht ganz sicher

	[xi, yi] = ODE23s(f, Jf, y0, x0, T, h0, tol, tau, p);

	plot(xi,yi(:,1), '-o')
end
