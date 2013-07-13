% Verena Treitz, Stephan Hilb, Matthias Hofmann
% Numerik 2 Blatt 10
% Programmieraufgabe A 10.4
% Approximative Berechnung von U

function [U_h] = approx_U_h(f, b1, b2, b3, b4, n)
h = 1/(n+1);

% Berechnung von A_h (zuerst, da nur von n abh‰ngig)
I = eye(n);
T = 2*eye(n) - diag(ones(n-1,1),-1) - diag(ones(n-1,1),1);
A = 1/h^2 * (kron(I,T) + kron(T,I));

% Berechnung von B_h
B = zeros(n^2,1);
B(1) = -b1(h) - b3(h);
B(n^2) = -b2(n*h) - b4(n*h);
for j = 2:n
    B(j) = -b3(j*h); 
    B(n^2-n-1+j) = -b4((j-1)*h);
end

% Berechnung der Eintr‰ge von F - kleine Erkl‰rung unten
F = zeros(n^2,1);
for k = 1:n^2
    s = floor(k/n);
    v = [(k-s*n)*h; (s+1)*h];
    F(k) = f(v(1),v(2));
end
U_h = A\(F - B);
end
% Zur Berechnung der Eintr‰ge von F:
% F = (f_k) ein n^2-dim. Vektor, und f_k = f(v^(k)).
% Damit ist k = i+(j-1)n  (mit v^(k) = (i*h, j*h)),
% also muss k-i = (j-1)n sein, und i,j aus 1,...,n
% Auﬂerdem ist k = s*n +l, mit 0 <= s < n und 0 < l <= n nat¸rliche Zahlen.
% Daraus ergibt sich dann obige Vorschrift f¸r v:
% s*n + l -i = (j-1)*n --> i = l = k - s*n und j = s+1