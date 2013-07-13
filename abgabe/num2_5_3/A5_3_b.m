% Numerik 2, Blatt 5
% Verena Treitz, 2665281
% Aufgabe 5.3, Aufgabenteil b)
% Testfunktion

function [] = A5_3_b()
A = [0,0,0,0,0; 1/2,0,0,0,0; 0,1/2,0,0,0; 0,0,1,0,0; 1/6,2/6,2/6,1/6,0];
b1 = [1/6; 2/6; 2/6; 1/6; 0];
b2 = [1/6; 2/6; 2/6; 0; 1/6];
c = [0; 1/2; 1/2; 1; 1];
y0 = [1.01; 3];
x0 = 0;
%T = 11;
T = 20;
h0 = 1;
tol = (1/10)^5;
tau = 0.9;
p = 3;

% Da dieses f nicht von x abhängt, sondern nur y1 und y2
f = @(y1,y2) [ 1 + y1^2*y2 - 4*y1 ; 3*y1 - y1^2*y2 ];

[xi, hat_yi] = RKV_expl_embedded1(A,b1,b2,c,f,y0,x0,T,h0,tol,tau,p);

% Für den letzten geforderten Plot werden die h_i benötigt.
% Ich habe mal für x0 h = h0 gesetzt, so dass dann jeweils zu x_i h_i =
% h(i+1) aufgetragen wird
n = length(xi);
h = zeros(n-1,1);
h(1) = h0;
for k = 2:n
    h(k) = xi(k) - xi(k-1);
end
y1 = hat_yi(:,1);
y2 = hat_yi(:,2);

figure(1)
hold on
plot(xi,y1, 'r');
plot(xi,y2, 'b');
hold off

figure(2)
plot(y1,y2);

figure(3) 
plot(xi,h, '.r');

end