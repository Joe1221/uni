function B = b_spline (n, H)
    x = -n : (1 / H) : (n + 1)
    b = zeros(n + 1, length(x));
    b(1,:) = real(x >= 0 & x < 1);

    for k = 1:n
        % values for k-th b-spline
        b(k+1,k*H+1:end) = ( x(k*H+1:end) .* b(k,k*H+1:end) + ...
                   (k + 1 - x(k*H+1:end)) .* b(k,(k-1)*H+1:end-H) ) / k;

        % derivatives up to order k for b-spline of degree k
        % (replacing derivatives of orders up to k-1 of b-splines up to degree k-1)
        b(1:k,k*H+1:end) = b(1:k,k*H+1:end) - b(1:k,(k-1)*H+1:end-H);
    end

    B = flipdim(b(:,n*H+1:end), 1);
    %plot(x(n*H+1:end), B);
end
