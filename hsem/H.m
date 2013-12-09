% Berechnet aus der aktuellen Approx.-Kurve die f-Werte auf C

function [f2] = H(obj, Gamma)
model.setInnerBoundary(obj, Gamma);
obj.geom.run;  % Geometrie aktualisieren

meshAndCompute(obj); % Lösen


f2 = getFValue(obj); % noch zu machen!!
end