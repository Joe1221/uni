#ifndef INDEX_H
#define INDEX_H

#include <cassert>
#include "Rational.h"
#include "Polynomial.h"
#include "Interval.h"

template<class R, class V, unsigned int dim = 1>
class Index {
    protected:
        std::array<Polynomial<R, dim>, dim + 1> _pVec;
        std::array<Interval<V>, dim> _iVec;

    public:
        Index (std::array<Polynomial<R, dim>, dim + 1> pVec, std::array<Interval<V>, dim> iVec)
                : _pVec(pVec), _iVec(iVec) { };

        template<unsigned int dim2 = dim, typename std::enable_if<dim2 != 0, int>::type = 0>
        friend std::ostream& operator<< (std::ostream& os, const Index& index) {
            os << "[" << std::endl;
            os << "   ";
            os << index._pVec[0] << " :" << std::endl;
            for (int i = 1; i <= dim; ++i) {
                os << "   ";
                os << index._pVec[i];
                if (i < dim)
                    os << "," << std::endl;
            }
            os << std::endl << "|" << std::endl;
            os << "   ";
            for (int i = 0; i < dim; ++i) {
                os << index._iVec[i];
                if (i < dim - 1)
                    os << " × ";
            }
            os << std::endl;
            os << "]";
            return os;
        }

        template<unsigned int dim2 = dim, typename std::enable_if<dim2 == 0, int>::type = 0>
        friend std::ostream& operator<< (std::ostream& os, const Index& index) {
            R val = index.getPolynomial(0);
            os << "[" << val << "]";
            return os;
        }

        const Polynomial<R, dim>& getPolynomial(unsigned int k) const {
            return _pVec.at(k);
        }
        const Interval<V>& getInterval(unsigned int k = dim - 1) const {
            return _iVec.at(k);
        }
        const std::array<Interval<V>, dim - 1> getOtherIntervals(unsigned int j = dim - 1) const {
            std::array<Interval<V>, dim - 1> intervals;

            std::copy(_iVec.begin(), std::next(_iVec.begin(), j), intervals.begin());
            std::copy(std::next(_iVec.begin(), j + 1), _iVec.end(), std::next(intervals.begin(), j));

            return intervals;
        }
        void setPolynomial(unsigned int k, Polynomial<R> p) {
            _pVec.at(k) = p;
        }
/*
        Index<R,getLowerBoundaryTerm (unsigned int k) const {
        }

        getUpperBoundaryTerm (unsigned int k) const {
        }
*/
        template<unsigned int dim2 = dim>
        typename std::enable_if<dim2 != 0, Rational>::type calc_idx () {

            auto res = Rational(0, 1);

            auto p = getPolynomial(0);

            // Reduction
            if (p.totalDegree() == 0) {
                std::cout << "Reduction of " << *this << std::endl;

                auto lP = std::array<Polynomial<R, dim - 1>, dim>();
                auto rP = std::array<Polynomial<R, dim - 1>, dim>();

                for (int j = 1; j <= dim; ++j) {
                    auto interval = getInterval(j - 1);
                    auto other_intervals = getOtherIntervals(j - 1);

                    for (int i = 0; i < dim; ++i) {
                        auto p = getPolynomial(i + 1);
                        lP[i] = p.stable_eval(interval.left());
                        rP[i] = p.stable_eval(interval.right());
                    }
                    Index<R, R, dim - 1> idxl(lP, other_intervals);
                    Index<R, R, dim - 1> idxr(rP, other_intervals);

                    Rational left = idxl.calc_idx();
                    Rational right = idxr.calc_idx();
                    std::cout << "... left: " << idxl << ", right: " << idxr << std::endl;

                    if (j % 2 == 0) {
                        res += right - left;
                    } else {
                        res -= right - left;
                    }
                }
                return res;
            }

            // Elimination
            std::cout << "Elimination of " << *this << std::endl;
            for (int i = 1; i <= dim; ++i) {
                if (getPolynomial(i).degree() == 0)
                    continue;
                std::cout << "... in position " << i << std::endl;

                Polynomial<R, dim> q = getPolynomial(i);

                auto pseq = prem_seq(p, q);
                std::cout << "... prem_seq result " << std::endl;
                for (auto p : pseq) {
                    std::cout << p << std::endl;
                }
                std::cout << std::endl;

                for (int j = 1; j < pseq.size() - 1; ++j) {
                    Index<R, V, dim> inversion_index = *this;
                    inversion_index.setPolynomial(0, Polynomial<R, dim>::One());
                    inversion_index.setPolynomial(i, pseq[j] * pseq[j+1]);

                    std::cout << "... inversion term " << j << ", value: " << inversion_index << std::endl;

                    res += inversion_index.calc_idx();
                }
            }
            return res;
        }

        template<unsigned int dim2 = dim>
        typename std::enable_if<dim2 == 0, Rational>::type calc_idx () {
            R val = getPolynomial(0);
            if (val > 0) {
                return 1;
            } else if (val < 0) {
                return -1;
            } else {
                return 0;
            }
        }

};


#endif
