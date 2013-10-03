% Verena Treitz, Stephan Hilb, Matthias Hofmann

% Numerik 2 Blatt 8
% Programmieraufgabe 8.3 
% Aufgabenteile a) - c): Testfunktion sowie Plot

% Ich habe Teile dieser Testfunktion von der Musterlösung für Aufgabe 4.5
% b) übernommen, insbesondere die Funktionen f und y sowie die 
% Deklarationen und den Plot (was sollte man da auch groß anders machen?)

function [] = testac()
clf;
% Die Funktion sowie die exakte Lösung
f = @(Y) [Y(2,:); -3*Y(1,:)];
y = @(t) [0.8*cos(sqrt(3)*t);-0.8*sqrt(3)*sin(sqrt(3)*t)];

% Die Ableitung von f (da y 2-dim. ist):
Jf = @(t) [0, -3; 1, 0];

g = @(x,y) [y(2,:); -3*y(1,:)];
gy = @(x,y) [0, -3; 1, 0];

% Startwerte:
y0 = [0.8;0];
x0 = 0;

% Deklarationen:
f_abs = zeros(1,10);
T = 1;
y_von_1 = y(1);

h=zeros(1,10);
for i = 1:10
    h(i)=2^(-i);
end

methods = { {@linear_impl_Euler, 'Linear impliziter Euler'}; ...
            {@linear_impl_midpoint, 'Linear implizite Mittelpunktsregel'}; ...
            {@ODE2s, 'ODE2s'}; ...
            {@ODE3s, 'ODE3s'}; ...
            {@Adams_Bashforth_2, 'Adams-Bashforth'}; ...
            {@Milne_Simpson_2, 'Milne-Simpson (version=1)'}; ...
            {@Milne_Simpson_2, 'Milne-Simpson (version=2)'} };

title('Fehlerplot')
for j = 1:4
    method = methods{j};

    subplot(5,2,j);
    for i = 1:10
        [t,y] = method{1}(x0, y0, h(i), f, Jf, T);
        f_abs(i) = norm(y(:,end) - y_von_1);
    end
    loglog(h, f_abs);
    legend(method{2}, 'location', 'NorthWest');
    ylabel('Norm des absoluten Fehlers')
    xlabel('Schrittweite h')
end

subplot(5,2,5);
for i = 1:10
    [t,y] = methods{5}{1}(x0, y0, h(i), f, T);
    f_abs(i) = norm(y(:,end) - y_von_1);
end
loglog(h, f_abs);
legend(methods{5}{2}, 'location', 'NorthWest');
ylabel('Norm des absoluten Fehlers')
xlabel('Schrittweite h')

subplot(5,2,7);
for i = 1:10
    [t,y] = methods{6}{1}(x0, y0, h(i), g, gy, T, 1);
    f_abs(i) = norm(y(:,end) - y_von_1);
end
loglog(h, f_abs);
legend(methods{6}{2}, 'location', 'NorthWest');
ylabel('Norm des absoluten Fehlers')
xlabel('Schrittweite h')

subplot(5,2,8);
for i = 1:10
    [t,y] = methods{7}{1}(x0, y0, h(i), g, gy, T, 2);
	%y'
    f_abs(i) = norm(y(:,end) - y_von_1);
end
loglog(h, f_abs);
legend(methods{7}{2}, 'location', 'NorthWest');
ylabel('Norm des absoluten Fehlers')
xlabel('Schrittweite h')
