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

    auto q = Polynomial<Integer, 2>({
        Monomial<Integer, 2>(1, {0, 1})
    });
    Polynomial<Integer, 1> q1 = {0, 1};
    Polynomial<Integer, 1> q2 = {1};
    REQUIRE( q.stable_eval(Integer(1), 0) == q1 );
    REQUIRE( q.stable_eval(Integer(1), 1) == q2 );
}

