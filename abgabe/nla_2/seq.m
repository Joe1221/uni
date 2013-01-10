% Vorraussetzung: n >= 2
function [ s ] = seq( n )
    % Startwert
    s(2) = 2;
    for i = 2:n-1
        % Rekursive Folgendefinition
        s(i+1) = 2^(i-0.5) * sqrt(1 - sqrt(1 - 4^(1-i)*s(i)^2));
    end
    % Die Folge startet erst bei n=2:
    s = s(2:n);
end

