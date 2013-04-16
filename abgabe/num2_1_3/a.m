h = 0.0005;
T = 10;
y0 = [10, 1];
r = [2, 4];
f = [2, 1];

[y1, y2] = RaeuberBeute(T, h, y0, r, f);

plot( (0:20000-1)*h, y1, ...
      (0:20000-1)*h, y2);

legend('y1', 'y2');
xlabel('Zeit'), ylabel('Population');
