function rfct (wfile, op, w1, w2)
    w1 = load(w1).w;
    if (nargin > 3)
        w2 = load(w2).w;
    end
    switch op
        case 'union'
            w = @(x)w1 + w2 + sqrt(w1.^2 + w2.^2);
            break
        case 'intersection'
            w = w1 + w2 - sqrt(w1.^2 + w2.^2);
            break
        case 'complement'
            w = -w1;
            break
    end
    save(wfile, 'w');
end
