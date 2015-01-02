#include "gcd.h"
#include <cassert>



template<class R>
std::vector<Polynomial<R>> pseudo_euclidean_division (Polynomial<R> p, Polynomial<R> q) {
    if (p.degree() < q.degree())
        std::swap(p, q);

    std::vector<Polynomial<R>> pseq = {p, q};
    Polynomial<R> p1 = pseq[0];
    Polynomial<R> p2 = pseq[1];

    int d = p1.degree() - p2.degree() + 1;

    /* compute p *= qlead ^ d */
    /*R qlead = q.lead();
    while (d > 0) {
        if ((d & 1) != 0)
            p1 *= qlead;
        d >>= 1;
        qlead *= qlead;
    }*/

    while (p2.degree() > 0) {
        std::cout << "start it" << std::endl;
        //std::cout << p1 << std::endl;
        while (p1.degree() >= p2.degree()) {
            R p1lead = p1.lead();
            std::cout << p1 << std::endl;
            p1 *= p2.lead();
            std::cout << p1 << std::endl;
            p1 -= p1lead * Polynomial<R>::Monomial(p1.degree() - p2.degree()) * p2;
            std::cout << p1 << std::endl;
        }
        std::cout << "end it" << std::endl;
        pseq.push_back(p1);
        std::swap(p1, p2);
    }

    return pseq;
}
