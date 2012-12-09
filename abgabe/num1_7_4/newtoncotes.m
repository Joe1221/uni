% Stephan Hilb, 2706616

function I = newtoncotes (fh, n)
	% Stuetzstellen
	omega = vander([0:n] ./ n)' \ (1 ./ [n+1:-1:1])';
	% Auswertung
	I = sum(omega' .* fh(linspace(0,1,n+1)));
end
