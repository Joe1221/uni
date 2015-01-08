#ifndef INDEX_H
#define INDEX_H

#include <cassert>
#include "Interval.h"
#include "Polynomial.h"

template<class T, class R>
class Index {
    public:
        unsigned int n;
        std::vector<Polynomial<T>> P;
        std::vector<Interval<R>> I;

    public:
        Index (std::vector<Polynomial<T>> P, std::vector<Interval<R>> I) : P(P), I(I), n(I.size()) {
            assert(P.size() == this->n + 1 && "polynomial vector and interval vector size mismatch");
        };

        const unsigned int degree () const {
            return this->n;
        }

        friend std::ostream& operator<< (std::ostream& os, const Index& index) {
            os << "[" << std::endl;
            os << "   ";
            os << index.P[0] << " :" << std::endl;
            for (int i = 1; i <= index.degree(); ++i) {
                os << "   ";
                os << index.P[i];
                if (i < index.n)
                    os << "," << std::endl;
            }
            os << std::endl << "|" << std::endl;
            os << "   ";
            for (int i = 0; i < index.degree(); ++i) {
                os << index.I[i];
                if (i < index.n - 1)
                    os << " × ";
            }
            os << std::endl;
            os << "]";
            return os;
        }

        const Polynomial<T>& getPolynomial(unsigned int k) const {
            return P[k];
        }
        const Interval<R>& getInterval(unsigned int k) const {
            return I[k];
        }
        const Interval<R>& getInterval() const {
            return I[this->degree() - 1];
        }
        void setPolynomial(unsigned int k, Polynomial<T> p) {
            P[k] = p;
        }
/*
        Index<R,getLowerBoundaryTerm (unsigned int k) const {
        }

        getUpperBoundaryTerm (unsigned int k) const {
        }
*/

};


#endif
