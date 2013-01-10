% Teil c)

for n=[10,100,500,1000]
    A = generate_test_matrix(n);
    b = ones(n,1);
    
    [L, R] = myLR(A);
    my_x = mysolve(L, R, b);
    x = A\b;
    
    rel_error = norm(my_x - x, 2) / norm(x, 2)
end

% Teil d)

for n=[5,10,15,20]
    b = zeros(n,1);
    x = zeros(n,1);
    for i=1:n
        for j=1:n
            A(i,j) = 1/(i+j-1);
            b(i) = b(i) + (-1)^(j-1) / (i+j-1);
        end
        x(i) = (-1)^(i-1);
    end
    
    [L, R] = myLR(A);
    my_x = mysolve(L, R, b);

    rel_error = norm(my_x - x, 2) / norm(x, 2)    
end


