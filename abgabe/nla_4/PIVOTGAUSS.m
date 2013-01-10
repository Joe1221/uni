function [ x ] = PIVOTGAUSS( A, b )
    [n,~] = size(A);
    L = eye(n);
    P = eye(n);
    for k = 1:n-1
        % Permutationsmatrix für den aktuellen Schritt
        P_k = eye(n);
        
        % Finde das richtige Pivotelement
        [~,index] = max( abs(A(k:n,k)) ./ sum(abs(A(k:n,:)),2) );
        index = index + k - 1;
        
        % tausche Zeilen
        A([index, k], :) = A([k, index], :);
        P_k([index, k], :) = P_k([k, index], :);
        
        % Normale LR-Zerlegung
        L(k+1:n, k) = A(k+1:n, k) / A(k, k);
        A(k+1:n, k:n) = A(k+1:n, k:n) - L(k+1:n, k) * A(k, k:n);
        
        % Korrigiere L
        L = P_k * L * P_k;
        % Speichere Gesamtpermutation
        P = P_k * P;
    end
    R = A;
    
    % Löse Lz = Pb =: c durch Vorwärtssubstitution
    z = zeros(n,1);    
    c = P*b;
    for i = 1:n
        z(i) = c(i) - sum(L(i, 1:i-1) * z(1:i-1));
    end
    
    % Löse Rx = z durch Rückwärtssubstitution
    x = zeros(n,1);
    for i = n:-1:1
        x(i) = (z(i) - sum(R(i, i+1:n) * x(i+1:n))) / R(i,i);
    end
end

