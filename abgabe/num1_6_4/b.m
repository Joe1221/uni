% Stephan Hilb, 2706616
D = double(imread('Bild_B6.png'));
E = error(D);
[m, n] = size(D);

e = [0.1, 0.05, 0.01, 0.001];
k = 1; i = 0;
while ++i < length(E) && k <= length(e) 
	if E(i) < e(k)
		K(k++) = i-1;
	end
end
K

[U, S, V] = svd(D);
for i = length(K):-1:1
	S(K(i):end,:) = 0;
	figure(i+1), imshow(uint8(U*S*V'));
end

J = m*K + n*K + K

