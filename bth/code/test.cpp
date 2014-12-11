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

	auto p = Polynomial<Integer>();


	for (auto exp = Integer(0); exp < Integer(10); ++exp) {
		algorithm(i);
	}

}

