#include "catch.hpp"

#include "../Integer.h"
#include "../Polynomial.h"

TEST_CASE( "Polynomial Initialization", "[polynomial]" ) {
    auto p = Polynomial<Integer> {5, 3, 1};

    REQUIRE( p.degree() == 2 );
}


TEST_CASE( "Polynomial Multiplication (one variable)", "[polynomial]" ) {
    auto p = Polynomial<Integer> {5, 3, 1}; // x^2 + 3*x + 5
    auto q = Polynomial<Integer> {4, 2, 7}; // 7*x^2 + 2*x + 4
    auto product = p * q;

    auto r = Polynomial<Integer> {20, 22, 45, 23, 7}; // 7*x^4 + 23*x^3 + 45*x^2 + 22*x + 20

    REQUIRE( product == r );
}

TEST_CASE( "Monomial Multiplication (two variables)", "[monomial]" ) {
    auto p = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(-1, {0, 0})
    }; // -1
    auto q = Polynomial<Integer, 2>::Monom(1); // x
    auto product = p * q;

    auto r = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(-1, {1, 0})
    }; // -x

    REQUIRE( product == r );
}

TEST_CASE( "Polynomial Multiplication (two variables)", "[polynomial]" ) {
    auto p = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(2, {1, 3}),
        Monomial<Integer, 2>(5, {2, 2}),
    }; // 2*x*y^3 + 5*x^2*y^2
    auto q = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(1, {5, 1}),
        Monomial<Integer, 2>(3, {0, 7}),
    }; // x^5*y + 3*y^7
    auto product = p * q;

    auto r = Polynomial<Integer, 2> {
        Monomial<Integer, 2>(2, {6, 4}),
        Monomial<Integer, 2>(6, {1, 10}),
        Monomial<Integer, 2>(5, {7, 3}),
        Monomial<Integer, 2>(15, {2, 9}),
    }; // 2*x^6*y^4 + 6*x*y^7 + 5*x^7*y^3 + 15*x^2*y^9

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
