#include "catch.hpp"

#include "../ramd.h"

TEST_CASE( "binomial 13 over 7", "[binomial]" ) {
    int n = 13;
    int k = 7;

    int b = binom(n, k);
    REQUIRE( b == 1716 );
}

