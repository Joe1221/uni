% Verena Treitz (2665281), Stephan Hilb (2706616), Matthias Hofmann

% Numerik 2 Blatt 8
% Programmieraufgabe 8.3 
% Aufgabenteil a): Linear-implizites Euler-Verfahren

function [xi, yi] = linear_impl_Euler(x0, y0, h, f, Jf, T)
    % Initialisierung der Vektoren sowie Dimensionen
    d  = length(y0);
    xi = x0:h:T;      % Äquidistante Stützstellen
    n  = length(xi);
    yi = zeros(d, n);

    yi(:,1) = y0;
    for i = 1:n-1
        % Berechnung mit dem linear-impliziten Euler-Verfahren
        k = (eye(d) - h * Jf(yi(:,i))) \ f(yi(:,i));
        yi(:,i+1) = yi(:,i) + h * k;
    end
end
