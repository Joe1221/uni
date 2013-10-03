% Verena Treitz , Stephan Hilb (2706616), Matthias Hofmann

% Numerik 2 Blatt 8
% Programmieraufgabe 8.3 
% Aufgabenteil e): Bonusaufgabe
% ode23s

function [xi, yi] = ODE23s(f, Jf, y0, x0, T, h0, tol, tau, p)
    % Initialisierung der Vektoren sowie Dimensionen
    d  = length(y0);
	xi = x0:h0:T; % damit der Vektor zumindest nicht bei jedem Schritt größer
					% wird - wird dann überschrieben
    n  = length(xi);
    yi = zeros(d, n);
	hat_yi = zeros(d, 1); % hat-y_i

    % Konstanten aus dem Verfahren
    a = 1/(2 + sqrt(2));
    d31 = - (4 + sqrt(2))/(2 + sqrt(2));
    d32 = (6 + sqrt(2))/(2 + sqrt(2));

	h = h0;
	yi(:,1) = y0;

	i = 1;
	while xi(i) < T
		% Berechnung mit dem 2-stufigen Verfahren aus ode23s:
		D = eye(d) - h/2 * Jf(yi(:,i)); % Temporäre Matrix
		
		k1 = D \ f(yi(:,i));
		k2 = D \ (f(yi(:,i) + h/2*k1) - a*h * Jf(yi(:,i)) * k1);
		k3 = D \ (f(yi(:,i) + h*k2) - d31*h * Jf(yi(:,i)) * k1 - d32*h * Jf(yi(:,i)) * k2);
		
        yi(:,i+1) = yi(:,i) + h * k2;
		hat_yi = yi(:,i) + h/6 * (k1 + 4*k2 + k3);
		
		% Berechnung Fehlerschätzer
		delta = norm(yi(:,i+1) - hat_yi);
		
		if delta > 0 % Berechnug der neuen Schrittweite
			h = tau*((tol/delta)^(1/(p+1)))*h;
		end
		
		if delta < tol % Test ob der Schritt wiederholt werden muss
			i = i + 1;
			xi(i+1) = xi(i) + h;
		end
	end
end
