n = 500;
minx = -1;
maxx = 1;
miny = -1;
maxy = 1;
kmax = 20;
epstol = 10^-4;

im = zeros(n,n,3);

for i = 1:n
	for j = 1:n
		x = minx + ((i-1)/(n-1)) * (maxx - minx);
		y = miny + ((j-1)/(n-1)) * (maxy - miny);

		[z, k] = findroot([x;y], kmax, epstol);
		switch (round(z))
			case [0;1]
				im(i,j,3) = k / kmax;
			case [0;-1]
				im(i,j,1) = k / kmax;
			case [1;0]
				im(i,j,2) = k / kmax;
			case [-1;0]
				im(i,j,1) = k / kmax;
				im(i,j,2) = k / kmax;
			otherwise
				im(i,j,:) = [1,1,1];
		endswitch
	end
end
imshow(im)
		
