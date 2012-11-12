% Stephan Hilb, 2706616

function C = ff2d (F)
	N = length(F);
	for j = 1:N
		C_1(:,j) = ff1d(F(:,j));
	end
	C_2 = transpose(C_1);
	for j = 1:N
		C_3(:,j) = ff1d(C_2(:,j));
	end
	C = transpose(C_3);
end
