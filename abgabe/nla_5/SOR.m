function [ x ] = SOR( omega )
    % Sehr unschöne Aufgabenstellung:
    % Die Art des Funktionsaufrufs ist vorgegeben, deshalb muss
    % der Startvektor und die Iteration auch innerhalb dieser Funktion
    % stattfinden, obwohl die Aufgabe es eigentlich anders verlangt,
    % nämlich, dass das SORSKRIPT die Iteration durchführt.
    
    % Parameter
    a = 10;
    h = 1/100;
    n = 100;
    
    % Generieren des LGS
    A = diag(-2 * ones(n,1)) ...
        + diag((1 - a*h/2) * ones(n-1,1), -1) ...
        + diag((1 + a*h/2) * ones(n-1,1), 1);    
    b = zeros(n,1);
    b(n) = -1 - a*h/2;
    
    % Algorithmus
    x = zeros(n,1);         % Startwert
    for k = 1:500
        for i = 1:n
            % Der Algorithmus arbeitet in-place mit x
            x(i) = (1 - omega)*x(i) + ...
                (omega/A(i,i)) * ( ...
                    b(i) - A(i,i+1:n)*x(i+1:n) - A(i,1:i-1)*x(1:i-1) ...
                );
        end
    end
end

