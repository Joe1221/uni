% Stephan Hilb, 2706616
function E = error(A)
	r = min(size(A));
	S = svd(A);

	E = S ./ norm(A); % Nach Satz 1.38 der Vorlesung
	E(r+1) = 0; % Mal abgesehen von Maschinenungenauigkeiten
end
