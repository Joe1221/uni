for i = [9,16,25]
    A = generate_test_matrix(i);
    % Werte zunächst mit unseren Funktionen aus
    [ N1, N2, Ninf, K1, K2, Kinf ] = MatrixInfo(A);
    info1 = [ N1, N2, Ninf, K1, K2, Kinf ]
    % dann mit den Matlab-Funktionen    
    info2 = [norm(A,1), norm(A,2), norm(A,Inf), cond(A,1), cond(A,2), cond(A,Inf)]
end
