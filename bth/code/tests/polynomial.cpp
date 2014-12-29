#include "catch.hpp"

#include "../Integer.h"
#include "../Polynomial.h"

TEST_CASE( "Polynomial Initialization", "[polynomial]" ) {
	auto p = Polynomial<Integer> {5, 3, 1};

	REQUIRE( p.degree() == 2 );
}

