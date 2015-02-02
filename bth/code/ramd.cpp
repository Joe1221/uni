#include "ramd.h"
#include "math.h"

/*inline int binom (int n, int k) {
    // symmetry
    if (k > n - k)
        k = n - k;
    if (k < 0)
        return 0;

    auto b1 = std::vector<int>(k + 1);
    auto b2 = std::vector<int>(k + 1);
    b1[0] = b2[0] = 1;

    for (int i = 1; i <= n; ++i) {
        for (int j = 1; j <= std::min(i, k); ++j) {
            b2[j] = b1[j-1] + b1[j];
        }
        b1 = b2;
    }

    return b1[k];
}

*/


/*template<class Integer>
T sign (Polynomial<R> p, T a) {
}*/

/*template<class R, unsigned int dim = 1>
Polynomial<R, dim - 1> stable_eval (Polynomial<R, dim> p, R a) {
    int n = p.degree();
    for (int k = 0; k <= n; ++k) {
        Polynomial<R, dim - 1> c = Polynomial<R, dim - 1>::Zero();
        for (int l = k; l <= n; ++l)
            c += binom(l, k) * p.coefficient(l) * pow(a, l - k);

        if (c == Polynomial<R, dim - 1>::Zero())
            continue;

        if ((k & 1) == 0) {
            return c;
        } else {
            return Polynomial<R, dim - 1>::Zero();
        }
    }
    return Polynomial<R, dim - 1>::Zero();
}*/






template<class R, unsigned int dim>
std::vector<Polynomial<R, dim>> neg_prem_seq (Polynomial<R, dim> p, Polynomial<R, dim> q) {

    std::vector<Polynomial<R, dim>> prem_seq = {p, q};

    while (q.degree() > 0) {
        int d, k = 0;

        while ((d = p.degree() - q.degree()) >= 0) {
            p = q.lead() * p - p.lead() * q * Polynomial<R, dim>::Monom(d);
            ++k;
        }
        if (k % 2 != 0)
            p *= q.lead();
        p = -p;

        prem_seq.push_back(p);
        std::swap(p, q);
    }

    return prem_seq;
}




template<class R, unsigned int dim>
std::vector<Polynomial<R, dim>> prem_seq (Polynomial<R, dim> p, Polynomial<R, dim> q) {

    std::vector<Polynomial<R, dim>> prem_seq = {p, q};

    while (q.degree() > 0) {
        int d, k = 0;

        while ((d = p.degree() - q.degree()) >= 0) {
            p = q.lead() * p - p.lead() * q * Polynomial<R, dim>::Monom(d);
            ++k;
        }
        if (k % 2 != 0)
            p *= q.lead();

        prem_seq.push_back(p);
        std::swap(p, q);
    }

    return prem_seq;
}
