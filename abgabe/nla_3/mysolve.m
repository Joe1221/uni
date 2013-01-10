function [ x ] = mysolve( L, R, b )
    [n,~] = size(b);
    % Löse Ly=b durch Vorwärtssubstitution    
    y = zeros(n,1);
    for i = 1:n
        y(i) = b(i) - sum(L(i, 1:i-1) * y(1:i-1));
    end
    
    % Löse Rx=y durch Rückwärtssubstitution
    x = zeros(n,1);
    for i = n:-1:1
        x(i) = (y(i) - sum(R(i, i+1:n) * x(i+1:n))) / R(i,i);
    end
end

