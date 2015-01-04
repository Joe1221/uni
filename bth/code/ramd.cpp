#include "ramd.h"
#include <cassert>

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
