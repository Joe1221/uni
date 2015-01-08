#ifndef RAMD_H
#define RAMD_H

#include <cassert>
#include <vector>
#include <algorithm>
#include "Polynomial.h"
#include "Order.h"
#include "RingEl.h"
#include "Rational.h"

int binom (int n, int k);

template<class R>
// fixme: const!
std::vector<Polynomial<R>> prem_seq (Polynomial<R> p, Polynomial<R> q);

#include "ramd.cpp"

#endif
