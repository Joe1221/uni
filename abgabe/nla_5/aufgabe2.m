
for i = 1:1000
   omega = i/500;
   A = [1-omega, -omega/2; (omega^2-omega)/3, omega^2/6-omega+1];
   B(1:2,i) = abs(eig(A));
   B(3:4,i) = imag(eig(A));
end

plot(transpose(B))