function [ lambda ] = vonMises( B )
    [~, n] = size(B);
    
    v = ones(n, 1);
    for i = 1:2*n
        w = v / mynorm(v, 2);
        v = B * w;
        theta = dot(v, w);
    end        
    lambda = theta;
end

