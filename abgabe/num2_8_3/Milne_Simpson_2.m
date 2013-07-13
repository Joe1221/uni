% Verena Treitz (2665281), Stephan Hilb (2706616), Matthias Hofmann

% Numerik 2 Blatt 8
% Programmieraufgabe 8.3 
% Aufgabenteil d): Bonusaufgabe
% Milne-Simpson-Verfahren mit m = 2:

function [xi, yi] = Milne_Simpson_2(x0, y0, h, f, fy, T, version)
    % Initialisierung der Vektoren sowie Dimensionen
    d  = length(y0);
    xi = x0:h:T;      % Äquidistante Stützstellen
    n  = length(xi);
    yi = zeros(d, n);

    if version == 1
        % RKV aus Aufgabe 5.1 b) zur Berechnung von y1
        eta1 = y0;
        eta2 = y0 + h/2 * f(x0, eta1);
        eta3 = y0 + h/2 * f(x0, eta2);
        eta4 = y0 + h   * f(x0, eta3);
        yi(:,2) = y0 + h/6 * (f(x0, eta1) + 2*f(x0, eta2) + 2*f(x0, eta3) + f(x0,eta4));
    elseif version == 2
        % Verfahren von Runge zur Bestimmung von y1
        yh = y0 + h/2 * f(x0, y0);
        yi(:,2) = y0 + h * f((xi(2) + x0)/2, yh);
    else 
       err('version must be 1 or 2!')
    end

    % Das Milne-Simpson-Verfahren für m = 2 lautet:
    % y_i+1 = y_i-1 + h/3*f_i-1 + 4/3*h*f_i + h/3*f(x_i+1,y_i+1)
    % Approximative Berechnung des impliziten Teiles durch das Newton-Verfahren
	yi(:,1) = y0;
    for i = 2:n-1
        F = @(z) z - yi(:,i-1) - h*(   1/3 * f(xi(i-1), yi(:,i-1)) ...
                                     + 4/3 * f(xi(i), yi(:,i)) ...
                                     + 1/3 * f(xi(i+1), z)      );
        DF = @(z) eye(d) - h/3 * fy(xi(i+1), z);

        yn = yi(:,i);   % Startwert für Newton
        for k = 1:3
            yn = yn - DF(yn) \ F(yn);
        end
        yi(:,i+1) = yn;
    end
end
