% Initialisierungsparameter
h = 0.0005;
T = 10;
y0 = [10, 1];
r = [2, 4];
f = [2, 1];

[y1, y2] = RaeuberBeute(T, h, y0, r, f);

% Plot
plot(y1, y2);
xlabel('y1'), ylabel('y2');

