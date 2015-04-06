#ifndef INDEX_H
#define INDEX_H

#include <iostream>
#include <sstream>

#include "Rational.h"
#include "Polynomial.h"
#include "Interval.h"
#include "cppformat/format.h"

template<class R, class V, unsigned int dim = 1>
class Index {
    protected:
        std::array<Polynomial<R, dim>, dim + 1> _pVec;
        std::array<Interval<V>, dim> _iVec;

        bool logging = false;

    public:
        Index (std::array<Polynomial<R, dim>, dim + 1> pVec, std::array<Interval<V>, dim> iVec)
                : _pVec(pVec), _iVec(iVec) { };

        /*template<unsigned int dim2 = dim, typename = typename std::enable_if<dim2 != 0>::type>
        friend std::ostream& operator<< (std::ostream& os, const Index<R, V, dim> & index) {
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
        }*/
        template<unsigned int dim2 = dim, typename = typename std::enable_if<dim2 != 0>::type>
        friend std::ostream& operator<< (std::ostream& os, const Index<R, V, dim> & index) {
            os << "[ ";
            os << index._pVec[0] << " : ";
            for (int i = 1; i <= dim; ++i) {
                os << index._pVec[i];
                if (i < dim)
                    os << ", ";
            }
            os << " | ";
            for (int i = 0; i < dim; ++i) {
                os << index._iVec[i];
                if (i < dim - 1)
                    os << "×";
            }
            os << " ]";
            return os;
        }

        template<unsigned int dim2 = dim, typename = typename std::enable_if<dim2 == 0>::type>
        friend std::ostream& operator<< (std::ostream& os, const Index<R, V, 0>& index) {
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
        void setPolynomial(unsigned int k, Polynomial<R, dim> p) {
            _pVec.at(k) = p;
        }
/*
        Index<R,getLowerBoundaryTerm (unsigned int k) const {
        }

        getUpperBoundaryTerm (unsigned int k) const {
        }
*/

        void setLogging (bool logging) {
            this->logging = logging;
        }

        template<class ... S>
        void log (unsigned int depth, S... tail) {
            if (!logging)
                return;

            //std::cout << std::string("> ", depth) << "| " << log(tail...) << std::endl;
            std::string indent;
            indent.reserve(2 * depth);
            for (int i = 0; i < depth; ++i)
                indent += "  ";

            std::cout << indent << "┃ " << logp(tail...) << std::endl;
        }
        template<class T, class ... S>
        std::string logp (const T& item, S... tail) {
            std::stringstream str;
            str << item;
            str << logp(tail...);
            return str.str();
        }
        template<class T>
        std::string logp (const T& item) {
            std::stringstream str;
            str << item;
            return str.str();
        }

        template<unsigned int dim2 = dim,
            typename std::enable_if<dim2 != 0, int>::type = 0>
        Rational calc_idx (unsigned int recursion_depth = 0) {

            auto res = Rational(0, 1);

            const auto& p = getPolynomial(0);
            const auto& q = getPolynomial(1);

            //fmt::print("Computing Index {}\n", *this);
            log(recursion_depth, "calculating ", *this , " …");
            //std::cout << std::string(recursion_depth, "> ") << "Computing Index " << *this << std::endl;

            if (p == Polynomial<R, dim>::Zero() || q == Polynomial<R, dim>::Zero()) {
                return Rational(0, 1);
            }

            // Reduction
            if (p.totalDegree() == 0) {
                log(recursion_depth, "reduction …");

                auto lP = std::array<Polynomial<R, dim - 1>, dim>();
                auto rP = std::array<Polynomial<R, dim - 1>, dim>();

                for (int j = 1; j <= dim; ++j) {
                    auto interval = getInterval(j - 1);
                    auto other_intervals = getOtherIntervals(j - 1);

                    if (dim > 1) {
                        for (int i = 1; i <= dim; ++i) {
                            auto s = getPolynomial(i);
                            lP[i - 1] = s.eval(interval.left(), j - 1);
                            rP[i - 1] = s.eval(interval.right(), j - 1);
                        }
                    } else {
                        auto s = getPolynomial(1);
                        lP[0] = s.eval(interval.left(), j - 1);
                        rP[0] = s.eval(interval.right(), j - 1);
                    }

                    Index<R, R, dim - 1> idxl(lP, other_intervals);
                    Index<R, R, dim - 1> idxr(rP, other_intervals);
                    idxl.setLogging(logging);
                    idxr.setLogging(logging);

                    if (dim > 1)
                        log(recursion_depth, "∂_", j, "^- = …");
                    Rational left = idxl.calc_idx(recursion_depth + 1);
                    log(recursion_depth, "∂_", j, "^- = ", left);

                    if (dim > 1)
                        log(recursion_depth, "∂_", j, "^+ = …");
                    Rational right = idxr.calc_idx(recursion_depth + 1);
                    log(recursion_depth, "∂_", j, "^+ = ", right);

                    if (j % 2 == 0) {
                        res -= right - left;
                    } else {
                        res += right - left;
                    }
                }
                return Rational(1, 2) * p.constCoefficient().signum() * res;
            }

            // Elimination
            log(recursion_depth, "elimination …");


            auto pseq = neg_prem_seq(q, p);
            log(recursion_depth, "neg_prem_seq result:");
            for (auto p : pseq) {
                log(recursion_depth, "  ", p);
            }

            for (int j = 0; j < pseq.size() - 1; ++j) {
                auto inversion_index = *this;
                inversion_index.setPolynomial(0, Polynomial<R, dim>::One());
                inversion_index.setPolynomial(1, pseq[j] * pseq[j + 1]);

                log(recursion_depth, "inversion term (", j, ")");
                auto invterm = inversion_index.calc_idx(recursion_depth + 1);
                log(recursion_depth, "inversion term (", j, "): ", invterm);
                res += invterm;

            }



/*
            // TODO: fix dimensional
            for (int i = 1; i <= dim; ++i) {
                if (getPolynomial(i).degree() == 0)
                    continue;
                log(recursion_depth, "… in position");

                Polynomial<R, dim> q = getPolynomial(i);

                auto pseq = sturm_prem_seq(p, q);
                log(recursion_depth, "… prem_seq result");
                for (auto p : pseq) {
                    std::cout << p << std::endl;
                }
                std::cout << std::endl;

                for (int j = 1; j < pseq.size() - 1; ++j) {
                    Index<R, V, dim> inversion_index = *this;
                    inversion_index.setPolynomial(0, Polynomial<R, dim>::One());
                    inversion_index.setPolynomial(i, pseq[j] * pseq[j+1]);

                    log(recursion_depth, "… inversion term ", j, ", value: ", inversion_index);

                    res += inversion_index.calc_idx(recursion_depth + 1);
                }
            }*/
            return res;
        }

        template<unsigned int dim2 = dim,
            typename std::enable_if<dim2 == 0, int>::type = 0>
        Rational calc_idx (unsigned int recursion_depth = 0) {
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
