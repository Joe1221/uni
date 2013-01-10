load -ascii nos1.mtx
A=nos1;
A=sparse(A(2:628,1), A(2:628,2),A(2:628,3),A(1,1),A(1,2));

cond(A)
b = ones(size(A,1));
[B,c] = VORKOND(A,b);
cond(B)

x = A\b;

x_pivotgauss = PIVOTGAUSS(A,b);
x_pivotgauss_vorkond = PIVOTGAUSS(B,c);

norm(x,2) - norm(x_pivotgauss,2)
norm(x,2) - norm(x_pivotgauss_vorkond,2)