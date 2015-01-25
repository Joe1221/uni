#include <iostream>

#include "Integer.h"
#include "Polynomial.h"
#include "ramd.h"
#include "Index.h"

int main (int argc, char *argv[]) {

    //auto p1 = Polynomial<Integer>{-5, 2, 8, -3, -3, 0, 1, 0, 1};
    //auto p1 = Polynomial<Integer>{1};
    //auto p2 = Polynomial<Integer>{21, -9, -4, 0, 5, 0, 3};

    //auto p1 = Polynomial<Integer, 2>({Monomial<Integer, 2>(1, {1, 0})});
    //auto p2 = Polynomial<Integer, 2>({Monomial<Integer, 2>(1, {0, 1})});

    /*// x^2 - y^2
    auto p1 = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(1, {2, 0}),
        Monomial<Integer, 2>(-1, {0, 2}),
    };
    auto p2 = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(2, {1, 1}),
    };*/

    // z^3
    /*
    auto p1 = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(1, {3, 0}),
        Monomial<Integer, 2>(-3, {1, 2}),
    };
    auto p2 = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(3, {2, 1}),
        Monomial<Integer, 2>(-1, {0, 3}),
    };*/

    auto m1 = std::list<Monomial<Integer, 2>>();
    auto m2 = std::list<Monomial<Integer, 2>>();

    unsigned int n = 3;
    for (unsigned int k = 0; k <= n; ++k) {
        if (k & 1<<0) {
            if (k & 1<<1) {
                auto exps = std::array<unsigned int, 2> { n-k, k };
                m2.push_back(Monomial<Integer, 2>(-binom(n, k), exps));
            } else {
                auto exps = std::array<unsigned int, 2> { n-k, k };
                m2.push_back(Monomial<Integer, 2>(binom(n, k), exps));
            }
        } else {
            if (k & 1<<1) {
                auto exps = std::array<unsigned int, 2> { n-k, k };
                m1.push_back(Monomial<Integer, 2>(-binom(n, k), exps));
            } else {
                auto exps = std::array<unsigned int, 2> { n-k, k };
                m1.push_back(Monomial<Integer, 2>(binom(n, k), exps));
            }
        }
    }
    auto p1 = Polynomial<Integer, 2>(m1);
    auto p2 = Polynomial<Integer, 2>(m2);

    //auto pseq = prem_seq(p1, p2);

    std::array<Polynomial<Integer, 2>, 3> Pvec = {
        Polynomial<Integer, 2>::One(), p1, p2
    };
    std::array<Interval<Integer>, 2> Ivec = {
        Interval<Integer>(-1, 0),
        Interval<Integer>(0, 1)
    };

    auto index = Index<Integer, Integer, 2>(Pvec, Ivec);

    Rational idx = index.calc_idx();
    std::cout << "Calculated index: " << idx << std::endl;


    /*std::cout << index << std::endl;

    for (auto p : pseq) {
        std::cout << p << std::endl;
    }*/

}

