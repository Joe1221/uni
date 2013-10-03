% Verena Treitz , Stephan Hilb (2706616), Matthias Hofmann

% Numerik 2 Blatt 8
% Programmieraufgabe 8.3 
% Aufgabenteil b): ODE3s

function [xi, yi] = ODE3s(x0, y0, h, f, Jf, T)
    % Initialisierung der Vektoren sowie Dimensionen
    d  = length(y0);
    xi = x0:h:T;      % Äquidistante Stützstellen
    n  = length(xi);
    yi = zeros(d, n);

    % Konstanten aus dem Verfahren
    a = 1/(2 + sqrt(2));
    d31 = - (4 + sqrt(2))/(2 + sqrt(2));
    d32 = (6 + sqrt(2))/(2 + sqrt(2));

    yi(:,1) = y0;
    for i = 1:n-1
        % Berechnung mit dem 2-stufigen Verfahren aus ode23s:
        D = eye(d) - h/2 * Jf(yi(:,i)); % Temporäre Matrix
        
        k1 = D \ f(yi(:,i));
        k2 = D \ (f(yi(:,i) + h/2*k1) - a*h * Jf(yi(:,i)) * k1);
        k3 = D \ (f(yi(:,i) + h*k2) - d31*h * Jf(yi(:,i)) * k1 - d32*h * Jf(yi(:,i)) * k2);
        
        yi(:,i+1) = yi(:,i) + h/6 * (k1 + 4*k2 + k3);
    end
end
