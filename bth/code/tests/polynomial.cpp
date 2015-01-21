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

TEST_CASE( "Polynomial coefficients", "[polynomial]" ) {
    // p(x,y) = x*y + x^2
    Polynomial<Integer, 2> p {
        Monomial<Integer, 2>(1, {1, 1}),
        Monomial<Integer, 2>(1, {2, 0})
    };

    Polynomial<Integer, 1> x2 = {1}; // 1
    Polynomial<Integer, 1> x1 = {0, 1}; // x
    Polynomial<Integer, 1> y1 = {0, 1}; // x
    Polynomial<Integer, 1> y0 = {0, 0, 1}; // x^2

    REQUIRE( p.coefficient(2, 0) == x2 );
    REQUIRE( p.coefficient(1, 0) == x1 );
    REQUIRE( p.coefficient(1, 1) == y1 );
    REQUIRE( p.coefficient(0, 1) == y0 );

    SECTION( "single second variable coeff" ) {
        auto q = Polynomial<Integer, 2> {
            Monomial<Integer, 2>(1, {0, 1})
        };
        auto coeff = Polynomial<Integer, 1> { 1 };

        REQUIRE( q.coefficient(1, 1) == coeff );
    }
}
