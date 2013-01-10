x_exact = zeros(n,1);
for i = 1:n
    x_exact(i) = (1-exp(-i/10))/(1-exp(-10));
end

for i = 0:9    
    omega = 1 + i/10;
    
    x_sor = SOR(omega);
    
    err_rel = (norm(x_exact,2) - norm(x_sor,2))/norm(x_exact,2) 
end