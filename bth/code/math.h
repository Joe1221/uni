#ifndef MATH_H
#define MATH_H

#include <iostream>
#include <vector>

inline int binom (int n, int k) {
    // symmetry
    if (k > n - k)
        k = n - k;
    if (k < 0)
        return 0;

    auto b1 = std::vector<int>(k + 1);
    auto b2 = std::vector<int>(k + 1);
    b1[0] = b2[0] = 1;

    for (int i = 1; i <= n; ++i) {
        for (int j = 1; j <= std::min(i, k); ++j) {
            b2[j] = b1[j-1] + b1[j];
        }
        b1 = b2;
    }

    return b1[k];
}

template<class R>
R pow (R b, int e) {
    if (e == 0)
        return R::One();

    R res = R::One();
    while (e > 1) {
        if ((e & 1) == 1) {
            res *= b;
            --e;
        }
        b *= b;
        e >>= 1;
    }
    return b * res;
}

#endif
