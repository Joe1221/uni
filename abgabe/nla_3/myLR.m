function [ L, R ] = myLR( A )
    n = size(A);
    L = eye(n);
    for k = 1:n-1
        % Ich habe die einzelnen Schleifen durch Matrizenoperationen
        % ersetzt, weil es sonst bei großen Matrizen zu lange gedauert hat.
        % Der auskommentierte Code macht aber im Grunde genau das gleiche.
        % Indem ich es als Matrizenoperationen schreibe, führt Matlab das
        % ganze schneller aus.
        if A(k, k) == 0
            error('LR-Zerlegung nicht möglich');
        end
        L(k+1:n, k) = A(k+1:n, k) / A(k, k);
%         for i = k+1:n
%             L(i,k) = A(i,k) / A(k,k);
%         end
        A(k+1:n, k:n) = A(k+1:n, k:n) - L(k+1:n, k) * A(k, k:n);
%         for i = k+1:n
%             for j = k:n
%                 A(i,j) = A(i,j) - L(i,k) * A(k,j);
%             end
%         end
    end
    R = A;
end

