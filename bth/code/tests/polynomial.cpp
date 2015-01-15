#include "catch.hpp"

#include "../Integer.h"
#include "../Polynomial.h"

TEST_CASE( "Polynomial Initialization", "[polynomial]" ) {
    auto p = Polynomial<Integer> {5, 3, 1};

    REQUIRE( p.degree() == 2 );
}


TEST_CASE( "Polynomial Multiplication", "[polynomial]" ) {
    auto p = Polynomial<Integer> {5, 3, 1};
    auto q = Polynomial<Integer> {4, 2, 7};
    auto product = p * q;

    auto r = Polynomial<Integer> {20, 22, 45, 23, 7};

    REQUIRE( product == r );
}
