clear;

n = 500;
minx = -1;
maxx = 1;
miny = -1;
maxy = 1;
kmax = 20;
epstol = 10^-4;

% Funktion und Newton-Iteration
f = @(z) z.^4 - 1;
iter = @(z) (3.*z + z.^-3)./4;

% Matrix mit Startwerten aufbauen
Z = complex(meshgrid(minx:(maxx-minx)/(n-1):maxx), -meshgrid(minx:(maxx-minx)/(n-1):maxx)');
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
	hue = conv .* ((arg(round(Z)) + pi) ./ (2*pi));
	light = conv .* (k / kmax);

	im(:,:,1) = hue;
	im(:,:,2) = im(:,:,2) .* (1 - mask) + (1 - light).^(1/1.7) .* mask;
	im(:,:,3) = im(:,:,3) .* (1 - mask) + (light).^(1/1.7) .* mask;

	%imshow(hsv2rgb(im));
	%drawnow();

	Z = iter(Z);
	k++;
end

im = hsv2rgb(im);
imshow(im);
imwrite(im, "fraktal.png");
