#include <iostream>

#include "Integer.h"


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

	for (auto exp = Integer(0); exp < Integer(10); ++exp) {
		algorithm(i);
	}

}

