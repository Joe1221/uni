% Konvertierung Kurve durch Radien gegeben zu Koordinaten
% Als Mittelpunkt wird automatisch 0 genommen.
% Gegeben: r ist Vektor von gleichverteilten Radien
% Ausgabe: Matrix M mit den 2-dim. Koordinaten zu den Radien

% r = load('C.mat', '-ascii');

function [M] = convertCurve(r)
n = length(r);
phi0 = 2*pi/n;
M = zeros(n,2);

for k = 1:n
    phi = phi0 * (k-1);
    M(k,1) = r(k)*cos(phi);
    M(k,2) = r(k)*sin(phi);
end
end