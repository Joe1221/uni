for n=[10,15]
    A = zeros(n);
    b = zeros(n,1);
    x = zeros(n,1);
    for i=1:n
        for j=1:n
            A(i,j) = 1/(i+j-1);
            b(i) = b(i) + (-1)^(j-1) / (i+j-1);
        end
        x(i) = (-1)^(i-1);
    end
  
    [B,c] = VORKOND(A,b);
    x_pivotgauss = PIVOTGAUSS(A,b);
    x_pivotgauss_vorkond = PIVOTGAUSS(B,c);

    norm(x_pivotgauss - x, 2) / norm(x, 2)
    norm(x_pivotgauss_vorkond - x, 2) / norm(x, 2)
end