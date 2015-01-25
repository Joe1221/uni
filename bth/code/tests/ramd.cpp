#include "catch.hpp"

#include "../Integer.h"
#include "../ramd.h"

TEST_CASE( "stable evaluation", "[ramd]" ) {

    // x^3 - x^2 - x + 1 = (x-1)^2 * (x+1)
    auto p = Polynomial<Integer>{1, -1, -1, 1};

    // zero, crossing axis
    Integer eval1 = p.stable_eval(Integer(-1));
    REQUIRE( Integer(0) == eval1 );

    // (double) zero, non-crossing
    Integer eval2 = p.stable_eval(Integer(1));
    REQUIRE( Integer(2) == eval2 );

}

TEST_CASE( "stable evaluation 2", "[ramd]" ) {

    // q = y
    auto q = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(1, {0, 1})
    };

    auto q1 = Polynomial<Integer> {0, 1}; // = x
    auto q2 = Polynomial<Integer> {1}; // = 1

    REQUIRE( q.stable_eval(Integer(1), 0) == q1 );
    REQUIRE( q.stable_eval(Integer(1), 1) == q2 );
}

TEST_CASE( "index, simple cycles", "[index]" ) {

    for (unsigned int n = 1; n <= 5; ++n) {

        auto m1 = std::list<Monomial<Integer, 2>>();
        auto m2 = std::list<Monomial<Integer, 2>>();

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

        std::array<Polynomial<Integer, 2>, 3> Pvec = {
            Polynomial<Integer, 2>::One(), p1, p2
        };
        std::array<Interval<Integer>, 2> Ivec = {
            Interval<Integer>(-1, 1),
            Interval<Integer>(-1, 1)
        };

        auto index = Index<Integer, Integer, 2>(Pvec, Ivec);

        Rational idx = index.calc_idx();

        REQUIRE( idx == n );

    }
}
