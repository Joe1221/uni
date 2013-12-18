

function model = main2()
clear;

%import com.comsol.model.*
%import com.comsol.model.util.*

model = ForwardModel();

g = load('g.mat', '-ascii'); % Da wir die gemessenen g-Werte brauchen
M = [0,2,1; -3,0,2; 0,-2,3; 2,0,4];
model.setFValue(M);

C = load('C2.mat', '-ascii'); 
model.setOuterBoundary(C);

k = 0;

% Gamma_0 Anfangsapproximation
s = 1/10;
G_0 = (1-s)*C;
model.setInnerBoundary(G_0);

S =  % Stützstellen

N = size(S);
n = N(1);
eps = 1/100; % bisher willkürlich festgelegt

figure(k);
model.buildGeometry();
model.buildMesh();
model.runStudy();
model.makePlot();

% Auswertung der berechneten G-Werte an den Stützstellen
g2 = model.getGValue(S);
G = G_0;

while s > 1/100   % bislang willkürlich gewählt
    k = k+1;
    figure(k);
    GN = (1-s)*G;
    model.setInnerBoundary(GN);
    model.buildGeometry();
    model.buildMesh();
    model.runStudy();
    model.makePlot();

    gn = getGValue(S);
    a = 0; % zählt die Änderungen
    % Vergleiche für jede Stützstelle die g-Werte
    for j = 1:n
        if norm(g(j,:)-gn(j,:)) < norm(g(j,:)-g2(j,:))
            G(j,:) = GN(j,:);
            a = a+1;
        end
    end
    % keine Änderungen: Schrittweite verkleinern
    if a == 0
        s = s/2;
    end
end


end
