function [ cond ] = mycond( A, p )
    if nargin < 2
        cond = mynorm(A) * mynorm(inv(A));
    else
        cond = mynorm(A, p) * mynorm(inv(A), p);
    end
end

