#include "catch.hpp"

#include "../math.h"
#include "../Integer.h"

TEST_CASE( "binomial 13 over 7", "[binomial]" ) {
    int n = 13;
    int k = 7;

    int b = binom(n, k);
    REQUIRE( b == 1716 );

    REQUIRE( binom(5, 0) == 1 );
    REQUIRE( binom(19, -3) == 0 );
    /*REQUIRE( binom(6, 6) == 1 );
    REQUIRE( binom(6, 5) == 6 );*/
}

TEST_CASE( "pow function", "[pow]" ) {

    Integer a = -2;

    REQUIRE( pow(a, 0) == Integer::One() );
    REQUIRE( pow(a, 1) == a );
    REQUIRE( pow(a, 2) == Integer(4) );
    REQUIRE( pow(a, 3) == Integer(-8) );

}
