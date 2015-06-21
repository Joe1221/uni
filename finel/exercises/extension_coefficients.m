function E = extension_coefficients (J, L, n)
    m = length(J);
    Edim = (n+1) * ones(1, m);
    E = ones(Edim);
    % crazy matlab
    if (m == 1)
        E = ones(Edim, 1);
    end

    for nu = 1:m
        for idx = 1:numel(E)
            [icell{1:m}] = ind2sub(Edim, idx);
            i = cell2mat(icell);

            X = L(nu) : L(nu)+n;
            Y = zeros(1, n+1);
            Y(i(nu)) = 1;

            E(idx) = E(idx) * polyval(polyfit(X, Y, n), J(nu));
        end
    end

    E = round(E);
end
