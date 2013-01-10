function [ norm ] = mynorm( A, typ )
    if nargin < 2
        % Berechne die 2-Norm, wenn nichts angegeben
        norm = mynorm(A, 2);
    else
        if isvector(A)
            % Berechne für Vektoren die p-Norm
            norm = sum(abs(A).^typ)^(1/typ);
        elseif ismatrix(A)
            if typ == 1
                norm = max(sum(abs(A)));
            elseif typ == Inf
                norm = max(sum(abs(A.')));
            else
                norm = sqrt(vonMises(A.'*A));
            end
        end
    end
end

