function [ A ] = generate_test_matrix( n )
    % 4 in der Hauptdiagonalen
    A = diag(4*ones(n,1));
    % -2 in der ersten Nebendiagonalen
    A = A + diag(-2*ones(n-1,1),1) + diag(-2*ones(n-1,1),-1);
    % 1 in der zweiten Nebendiagonalen
    A = A + diag(ones(n-2,1),2) + diag(ones(n-2,1),-2);
end

