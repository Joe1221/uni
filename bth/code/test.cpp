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
    auto p1 = Polynomial<Integer>{-5, 2, 8, -3, -3, 0, 1, 0, 1};
    auto p2 = Polynomial<Integer>{21, -9, -4, 0, 5, 0, 3};

    /*auto vec = std::vector<Polynomial<Integer>>{p1, p2};
    auto t = Polynomial<Polynomial<Integer>>(vec);*/

    auto t1 = Polynomial<Polynomial<Integer>>{
        Polynomial<Integer>::Monomial(2),
        Polynomial<Integer>::Zero(),
        Polynomial<Integer>::One()
    };
    auto t2 = Polynomial<Polynomial<Integer>>{
        2 * Polynomial<Integer>::Monomial(1),
        - 2 * Polynomial<Integer>::One()
    };


    auto pseq = pseudo_euclidean_division(t1, t2);

    for (auto p : pseq) {
        std::cout << p << std::endl;
    }

}

