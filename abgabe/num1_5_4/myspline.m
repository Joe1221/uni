function S = myspline (X, Y)
	n = length(X);
	H = diff(X);
	
	A = diag(2*(H(1:n-2) + H(2:n-1)));
	A = A + diag(H(2:n-2), 1) + diag(H(2:n-2), -1);

	b = (6 ./ H(2:n-1)) .* (Y(3:n) - Y(2:n-1));
	b = b - (6 ./ H(1:n-2)) .* (Y(2:n-1) - Y(1:n-2)) ;

	M(1) = 0;
	M(2:n-1) = A \ b;
	M(n) = 0;
	M = transpose(M);

	S(1,:) = (M(2:n) - M(1:n-1)) ./ (6 * H);
	S(2,:) = M(1:n-1) ./ 2;
	S(3,:) = ((Y(2:n) - Y(1:n-1)) ./ H)  - (H .* (M(2:n) ./ 6 + M(1:n-1) ./ 3));
	S(4,:) = Y(1:n-1);

end
