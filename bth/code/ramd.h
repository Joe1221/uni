#ifndef RAMD_H
#define RAMD_H

#include <cassert>
#include <vector>
#include <algorithm>
#include "Polynomial.h"
#include "Interval.h"
#include "Index.h"
#include "Order.h"
#include "RingEl.h"
#include "Rational.h"

int binom (int n, int k);

template<class R, unsigned int dim = 1>
// fixme: const!
std::vector<Polynomial<R, dim>> prem_seq (Polynomial<R, dim> p, Polynomial<R, dim> q);

#include "ramd.cpp"

#endif
