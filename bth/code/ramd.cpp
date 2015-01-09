#include "ramd.h"

inline int binom (int n, int k) {
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



template<class R>
R pow (R b, int e) {
    R res = R::One();
    while (e > 1) {
        if ((e & 1) == 1) {
            res *= b;
            --e;
        }
        b *= b;
        e <<= 1;
    }
    return b;
}

template<class Integer>
T sign (Polynomial<R> p, T a) {
}

template<class R, class T>
T stable_eval (Polynomial<R> p, T a) {
    static_assert(std::is_base_of<RingEl<T>, T>::value,
            "Evaluation point must inherit from RingEl");

    int n = p.degree();
    for (int k = 0; k <= n; ++k) {
        T c = T::Zero();
        for (int l = k; l <= n; ++l)
            c += binom(l, k) * p[l] * pow(a, l - k);

        if (c == T::Zero())
            continue;

        if ((k & 1) == 0) {
            return c;
        } else {
            return T::Zero();
        }
    }
    return T::Zero();
}




template<class T, class R>
Rational calc_idx (const Index<T, R>& index) {

    auto res = Rational(0, 1);

    Polynomial<T> p = index.getPolynomial(0);

    if (p == Polynomial<T>::One()) {
        return 1;

        auto interval = index.getInterval();
        unsigned int n = index.degree();

        auto lP = std::vector<T>();
        auto rP = std::vector<T>();
        for (int i = 1; i <= n; ++i) {
            Polynomial<T> p = index.getPolynomial(i);
            lP.push_back(stable_eval<T, R>(p, interval.left()));
            Polynomial<T> q = index.getPolynomial(i);
            rP.push_back(stable_eval<T, R>(q, interval.right()));
        }
        /*// FIXME: alle!
        auto I = std::vector<Interval<R>>();
        for (int i = 1; i < n; ++i) {
            I.push_back(index.getInterval(i));
        }*/

        
    }


    for (int i = 1; i <= index.degree(); ++i) {
        if (index.getPolynomial(i).degree() == 0)
            continue;

        Polynomial<T> q = index.getPolynomial(i);

        auto pseq = prem_seq(p, q);

        for (int j = 1; j < pseq.size() - 1; ++j) {
            Index<T, R> inversion_index = index;
            inversion_index.setPolynomial(0, Polynomial<T>::One());
            inversion_index.setPolynomial(i, pseq[j] * pseq[j+1]);

            std::cout << "Inversion term:" << inversion_index;

            res += calc_idx(inversion_index);
        }
    }
    return res;
}






template<class R>
std::vector<Polynomial<R>> prem_seq (Polynomial<R> p, Polynomial<R> q) {

    std::vector<Polynomial<R>> prem_seq = {p, q};
    int d = p.degree() - q.degree() + 1;

    while (q.degree() > 0) {
        int d = p.degree() - q.degree();

        int k;
        for (
            k = 0, d = p.degree() - q.degree();
            d >= 0;
            ++k, d = p.degree() - q.degree()
        ) {
            R plead = p.lead();

            p *= q.lead();
            p -= plead * q * Polynomial<R>::Monomial(d);
        }
        if (k++ & 1)
            p *= q.lead();

        prem_seq.push_back(p);
        std::swap(p, q);
    }

    return prem_seq;
}
