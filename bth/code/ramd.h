#ifndef GCD_H
#define GCD_H

#include <vector>
#include <algorithm>
#include "Polynomial.h"

template<class R>
std::vector<Polynomial<R>> prem_seq (Polynomial<R> p, Polynomial<R> q);

#include "gcd.cpp"

#endif
