#include "catch.hpp"

#include "../ramd.h"

TEST_CASE( "binomial 13 over 7", "[binomial]" ) {
    int n = 13;
    int k = 7;

    int b = binom(n, k);
    REQUIRE( b == 1716 );

    REQUIRE( binom(5, 0) == 1 );
    REQUIRE( binom(19, -3) == 0 );
}

