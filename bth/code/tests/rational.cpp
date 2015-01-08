#include "catch.hpp"

#include "../Rational.h"

TEST_CASE( "rational arithmetic", "[rational]" ) {
    auto a = Rational(1, 2);
    auto b = Rational(2, 3);

    auto c = a + b;
    REQUIRE( c == Rational(7, 6) );

    auto d = a * b;
    REQUIRE( d == Rational(1, 3) );
}

