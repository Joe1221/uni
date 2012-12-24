% Stephan Hilb, 2706616

function B = richardson_extrapol (b, h, q = 1)
	n = length(h) - 1;

	% Die Auswertungen sind die selben und unabhaengig von q
	for i = 0:n
		B(i+1,1) = b(h(i+1));
	end
	% Modifiziere die h mit dem Parameter q
	h = h .^ q;
	for j = 1:n
		for i = 0:n-j
			B(i+1,j+1) = B(i+2,j) + (B(i+2,j) - B(i+1,j))/((h(i+1)/h(i+j+1)) - 1);
		end
	end
end
