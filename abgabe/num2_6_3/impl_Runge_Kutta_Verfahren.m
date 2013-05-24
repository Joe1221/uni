function [ ti, yi ] = impl_Runge_Kutta_Verfahren( t0, y0, h, f, fy, T, A, b, c )

    ti = t0:h:T;
    s = length(b);
    d = length(y0);
    N = length(ti);
         
    yi = zeros(d, N);
    yi(:,1) = y0;
    
    for i = 1:N-1
        eta = eta_approx(f, fy, A, c, h, ti(i), yi(:,i));
        
        % Stützstellen als s × 1 Vektor
        xargs = ti(i) * ones(s, 1) + h * c;
        
        % Runge-Kutta-Iteration
        yi(:,i+1) =  yi(:,i) + h * reshape(multi_f(f, xargs, eta, d, s), d, s) * b;        
    end
       
end

