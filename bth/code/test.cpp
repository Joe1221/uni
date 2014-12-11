#include <iostream>

#include "Integer.h"
#include "Polynomial.h"


template<class R>
void algorithm(Ring<R> & arg_)
{
	R &arg = static_cast<R&>(arg_);

	arg *= arg;
	std::cout << arg << std::endl;

}





int main (int argc, char *argv[])
{
	auto i = Integer(2);

	std::vector<Integer> c1 = { 5, 3 };
	auto p1 = Polynomial<Integer>(c1);

	std::vector<Integer> c2 = { 5, 3, 7, 2 };
	auto p2 = Polynomial<Integer>(c2);

	auto q = p2 * p2;
	std::cout << q << std::endl;


	for (auto exp = Integer(0); exp < Integer(10); ++exp) {
		algorithm(i);
	}

}

