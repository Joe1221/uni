#include <iostream>

#include "Integer.h"
#include "Polynomial.h"
#include "gcd.h"


template<class R>
void algorithm(RingEl<R> & arg_)
{
	R &arg = static_cast<R&>(arg_);

	arg *= arg;
	std::cout << arg << std::endl;

}





int main (int argc, char *argv[])
{
	auto i = Integer(2);

	auto p1 = Polynomial<Integer>{5, 3};
	auto p2 = Polynomial<Integer>{5, 3, 7, 2};

	std::cout << i * p1 << std::endl;
	std::cout << p2 << std::endl;
	auto q = p1 * p2;
	std::cout << q << std::endl;


	for (auto exp = Integer(0); exp < Integer(10); ++exp) {
		algorithm(i);
	}

}

