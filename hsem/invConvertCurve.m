% Konvertiert Kurve durch Koordinaten gegeben zu Radius mit Winkel (wenn
% nicht äquidistant)

function [R] = invConvertCurve(x)
m = size(x);
if m(2) ~= 2
    % Fehler
end
n = m(1); % Anzahl an Stützstellen
r = zeros(n,1); phi = zeros(n,1);
for k = 1:n
    z = [x(k,1); x(k,2)];
    r(k) = norm(z);    
    phi(k) = acos(z(1)/r);  % nicht in Grad
    
end




end