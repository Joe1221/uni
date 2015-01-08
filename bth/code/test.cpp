#include <iostream>

#include "Integer.h"
#include "Index.h"
#include "Polynomial.h"
#include "ramd.h"


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
        Polynomial<Integer>::One(),
        p2,
    };
    auto t2 = Polynomial<Polynomial<Integer>>{
        2 * Polynomial<Integer>::Monomial(1),
        - 2 * Polynomial<Integer>::One(),
        p1,
        p2
    };

    p1 = Polynomial<Integer>{-5, 2, 8, -3, -3, 0, 1, 0, 1};
    p2 = Polynomial<Integer>{21, -9, -4, 0, 5, 0, 3};

    auto pseq = prem_seq(p1, p2);

    auto Pvec = std::vector<Polynomial<Integer>>{p1, p2};
    auto Ivec = std::vector<Interval<Integer>>{Interval<Integer>(-1,1)};

    std::cout << Ivec.size() << std::endl;
    auto index = Index<Integer, Integer>(Pvec, Ivec);

    calc_idx(index);


    std::cout << index.degree() << std::endl;
    std::cout << index << std::endl;

    for (auto p : pseq) {
        std::cout << p << std::endl;
    }

}

