% Verarbeitet auch einen Vektor
function [ y ] = poly( x )
    y = x.^7 - 7.*x.^6 + 21.*x.^5 - 35.*x.^4 + 35.*x.^3 - 21.*x.^2 + 7.*x - 1;
end

