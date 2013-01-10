function [ L ] = CHOLESKY( A )
    n = size(A,1);
    L = zeros(n);
    
    for i = 1:n
       L(i,i) = sqrt(A(i,i) - sum( L(i,1:i-1).^2 ));       
       L(i+1:n,i) = (A(i+1:n,i) - ( L(i+1:n,1:i-1)  * transpose(L(i,1:i-1)) )) ./ L(i,i);
       
%        % Alternativ (langsamer) mit for-Schleife:
%        for k = i+1:n
%           L(k,i) = (A(k,i) - sum( L(i,1:i-1) .*  L(k,1:i-1) )) / L(i,i);
%        end
    end
end

