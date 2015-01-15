#include <iostream>

#include "Integer.h"
#include "Polynomial.h"
#include "ramd.h"
#include "Index.h"


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
    //auto p1 = Polynomial<Integer>{1};
    auto p2 = Polynomial<Integer>{21, -9, -4, 0, 5, 0, 3};

    auto pseq = prem_seq(p1, p2);

    std::array<Polynomial<Integer, 1>, 2> Pvec = {p1, p2};
    std::array<Interval<Integer>, 1> Ivec = {Interval<Integer>(-1,1)};

    auto index = Index<Integer, Integer, 1>(Pvec, Ivec);

    Rational idx = index.calc_idx();
    std::cout << "Calculated index: " << idx << std::endl;


    /*std::cout << index << std::endl;

    for (auto p : pseq) {
        std::cout << p << std::endl;
    }*/

}

