#include "ramd.h"
#include <cassert>



inline int binom (int n, int k) {
    int res = 1;
    // symmetry
    if (k > n - k)
        k = n - k;
    for (int i = 0; i < k; ++i) {
        res *= n - i;
        res /= i + 1;
    }
    return res;
}


template<class R>
class Interval {
    public:
        Interval (R a, R b) : a(a), b(b) {
            static_assert(std::is_base_of<RingEl<R>, R>::value,
                    "Coefficient class must inherit from RingEl");
            static_assert(std::is_base_of<Order<R>, R>::value,
                    "Coefficient class must inherit from Order");
        }
        const R& left () const {
            return a;
        }
        const R& right () const {
            return b;
        }
        const bool contains (const R& c) const {
            return a <= c && c <= b;
        }
    protected:
        R a;
        R b;
};

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


template<class R>
Rational calc_idx (std::vector<Polynomial<R>> Pvec, std::vector<Interval<R>> Ivec) {

}






template<class R>
std::vector<Polynomial<R>> prem_seq (Polynomial<R> p, Polynomial<R> q) {
    /*if (p.degree() < q.degree())
        std::swap(p, q);*/

    std::vector<Polynomial<R>> prem_seq = {p, q};
    int d = p.degree() - q.degree() + 1;

    while (q.degree() > 0) {
        //std::cout << "start it" << std::endl;
        //std::cout << p << std::endl;
        int d = p.degree() - q.degree();

        int k;
        for (
            k = 0, d = p.degree() - q.degree();
            d >= 0;
            ++k, d = p.degree() - q.degree()
        ) {
            R plead = p.lead();
            //std::cout << p << std::endl;
            p *= q.lead();
            //std::cout << p << std::endl;
            p -= plead * q * Polynomial<R>::Monomial(d);
            //std::cout << p << std::endl;
        }
        if (k++ & 1)
            p *= q.lead();
        //std::cout << "end it" << std::endl;
        prem_seq.push_back(p);
        std::swap(p, q);
    }

    return prem_seq;
}
