function [ B, c ] = VORKOND( A, b )
    D = diag( 1 ./ max(A,[],2));
    B = D*A;
    c = D*b;
end

