function [ N1, N2, Ninf, K1, K2, Kinf ] = MatrixInfo( A )
    N1 = mynorm(A, 1);
    N2 = mynorm(A, 2);
    Ninf = mynorm(A, Inf);
    K1 = mycond(A, 1);
    K2 = mycond(A, 2);
    Kinf = mycond(A, Inf);
end

