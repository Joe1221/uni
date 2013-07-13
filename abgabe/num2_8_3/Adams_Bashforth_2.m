% Verena Treitz (2665281), Stephan Hilb (2706616), Matthias Hofmann

% Numerik 2 Blatt 8
% Programmieraufgabe 8.3 
% Aufgabenteil c): Adams-Bashforth-Verfahren

function [xi, yi] = Adams_Bashforth_2(x0, y0, h, f, T)
    % Initialisierung der Vektoren sowie Dimensionen
    d  = length(y0);
    xi = x0:h:T;      % Äquidistante Stützstellen
    n  = length(xi);
    yi = zeros(d, n);

    yi(:,1) = y0;

    % Verfahren von Runge zur Bestimmung von y1
    yh = yi(:,1) + h/2 * f(yi(:,1));
    yi(:,2) = yi(:,1) + h * f(yh);

    for i = 2:n-1
        % Berechnung mit dem Adams-Bashforth-Verfahren
        yi(:,i+1) = yi(:,i) + h*( -1/2 * f(yi(:,i-1)) + 3/2 * f(yi(:,i)));
    end
end
