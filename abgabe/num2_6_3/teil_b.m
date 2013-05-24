% Teile hiervon wurden aus der Musterlösungvon Aufgabe 4.5 übernommen.

clear

f = @(t,Y) [Y(2,:); -3*Y(1,:)];
fy = @(t,Y) [0,1; -3,0];
y_exact = @(t) [0.8*cos(sqrt(3)*t);-0.8*sqrt(3)*sin(sqrt(3)*t)];

t0 = 0;
y0 = [0.8; 0];
T = 1;
yend = y_exact(1); % Tatsächliche Lösung für den Fehlervergleich später

% Implizite Mittelpunktsregel
A{1} = [0.5];
b{1} = [1];
c{1} = [0.5];

% Crank-Nicolson Verfahren
A{2} = [0, 0; 0.5, 0.5];
b{2} = [0.5; 0.5];
c{2} = [0; 1];

for i = 1:10 
    h(i) = 2^(-i);
    
    for j = 1:2
        [t{j}, y{j}] = impl_Runge_Kutta_Verfahren(t0, y0, h(i), f, fy, T, A{j}, b{j}, c{j});
        f_rel{j}(i) = norm(y{j}(:, end) - yend);
    end
end

loglog(h, f_rel{1}, h, f_rel{2});

legend('Implizite Mittelpunktsregel','Crank-Nicolson Verfahren');
title('Fehlerplot')
ylabel('Norm des absoluten Fehlers')
xlabel('Schrittweite h')