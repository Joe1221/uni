n = 700;

T = rand(n);
S = T*transpose(T);

eig(S);

L = CHOLESKY(S);

P= L*transpose(L);
S;

(norm(S) - norm(P)) / norm(S)
