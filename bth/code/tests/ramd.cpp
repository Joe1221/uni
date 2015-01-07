#include "catch.hpp"

#include "../Integer.h"
#include "../ramd.h"

TEST_CASE( "stable evaluation", "[ramd]" ) {

    // x^3 - x^2 - x + 1 = (x-1)^2 * (x+1)
    auto p = Polynomial<Integer>{1, -1, -1, 1};

    // zero, crossing axis
    Integer eval1 = stable_eval(p, Integer(-1));
    REQUIRE( Integer(0) == eval1 );

    // (double) zero, non-crossing
    Integer eval2 = stable_eval(p, Integer(1));
    REQUIRE( Integer(2) == eval2 );
}

