% Verena Treitz, Matthias Hofmann, Stephan Hilb
% Numerik 2 Blatt 10
% Programmieraufgabe 10.4
% Aufgabenteil c)

function [] = testc()
n = 50;

% die angegebenen Randwerte
b1 = @(x) 0;
b2 = @(x) 0;
b3 = @(x) 0;
b4 = @(x) sin(2*pi*x);

f = @(x,y) 0;

% Berechnung
U_h = approx_U_h(f,b1,b2,b3,b4,n);

% Visualisierung
figure %zur Nacheinander-Ausführung beider Aufgabenteile
h = 1/(n+1);
U_h_matrix = reshape(U_h,n,n)';
[X, Y] = meshgrid(h:h:(1-h), h:h:(1-h));
surf(X, Y, U_h_matrix, 'FaceColor','interp','EdgeAlpha',0);
xlabel('x-Achse');
ylabel('y-Achse');
zlabel('z-Achse');
end