#include "catch.hpp"

#include "../Integer.h"

TEST_CASE( "Integer additon", "[integer]" ) {
	auto i = Integer(3);
	auto j = Integer(-8);

	auto k = i + j;

	REQUIRE( k == -5 );
}

