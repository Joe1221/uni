function [ eta ] = eta_approx( f, fy, A, c, h, x, y, eps_tol)
    s = length(c); % Stufenanzahl
    d = length(y); % Anzahl Dimensionen
    
    if nargin < 8
        eps_tol = 10^-5; % Default Toleranz
    end
    
    % Stützstellen als s × 1 Vektor
    xargs = x * ones(s, 1) + h * c;
    
    % N(η) als Funktion
    N = @(eta) ...
        eta - kron(ones(s,1), y) ...
            - h * kron(A, eye(d)) ...
                * multi_f(f, xargs , eta, d, s);
            
    % N'(η) als Funktion
    DN = @(eta) ...
        eye(d*s, d*s) ...
            - h  * kron(ones(d,d), A) ...
                .* kron(ones(s,1), multi_f(fy, xargs, eta, d, s)');
    
    % Newton-Verfahren       
    eta = kron(ones(s, 1), y);   
    while norm(N(eta)) > eps_tol    
        eta = eta - DN(eta) \ N(eta);
    end
   
end

