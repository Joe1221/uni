clear;

n = 500;
minx = -2;
maxx = 2;
miny = -2;
maxy = 2;
kmax = 20;
epstol = 10^-4;

% Funktion und Newton-Iteration
m = 4 % m-te Einheitswurzeln als Nullstellen
f = @(z) z.^m - 1;
iter = @(z) ((m-1).*z + z.^-(m-1))./m;

% Matrix mit Startwerten aufbauen
Z = complex(meshgrid(minx:(maxx-minx)/(n-1):maxx), -meshgrid(miny:(maxy-miny)/(n-1):maxy)');
im = zeros(n,n,3);
im(:,:,3) = ones(n, n); % Weiß


k = 0;
conv = zeros(n,n); % (bool) Wert unter der Toleranzgrenze
while k <= kmax
	conv_old = conv;
	conv = (abs(f(Z)) < epstol);
	% Maske derjenigen Pixel, die in diesem Schritt unter die Toleranz fallen
	mask = conv - conv_old; 

	% Farbwert als Argument der komplexen Zahl
	hue = conv .* ((angle(Z) + pi) ./ (2*pi));
	light = conv .* (k / kmax) * (pi/2);

	im(:,:,1) = hue;
	im(:,:,2) = im(:,:,2) .* (1 - mask) + cos(light) .* mask;
	im(:,:,3) = im(:,:,3) .* (1 - mask) + sin(light) .* mask;

	%imshow(hsv2rgb(im));
	%drawnow();

	Z = iter(Z);
	k = k + 1;
end

im = hsv2rgb(im);
imshow(im);
imwrite(im, 'fraktal.png');
