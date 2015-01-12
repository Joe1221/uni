#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#include <initializer_list>
#include <gmpxx.h>

#include "RingEl.h"

// should be private to Polynomial
template<class R, unsigned int dim = 1>
class Monomial : public SetEl<Monomial<R, dim>> {
    protected:
        R coefficient;
        std::array<unsigned int, dim> exponents;
    public:
        Monomial (std::initalizer_list<unsigned int> exponents, R coefficient == R::One())
                : exponents(exponents), coefficient(coefficient) {
            // assert(exponents.size() == d) ?
        }

        //Monomial& operator= (const Monomial& rhs) { /* */ return *this; }

        /*const R& operator[] (int i) const {
            if (i < 0 || i > degree()) return coeffZero;
            return coeffs[i];
        }*/

        const unsigned int exponent (unsigned int i) {
            return this->exponents[i];
        }

        const R& coefficient () const {
            return this->coefficient;
        }

        // SetEl, equality, != for free
        friend bool operator== (const Monomial& lhs, const Monomial& rhs) {
            return lhs.coefficient == rhs.coefficient && lhs.exponents == rhs.exponents;
        }

        /*
        Monomial& operator*= (const Monomial& rhs) {
        }

        Monomial& operator*= (const R& rhs) {
            int newDegree = 0;
            for (int i = 0; i <= this->degree(); ++i) {
                this->coeffs[i] *= rhs;
                if (coeffs[i] != R::Zero())
                    newDegree = i;
            }
            this->n = newDegree;
            return *this;
        }
        friend Polynomial& operator* (Polynomial lhs, const R& rhs) { return lhs *= rhs; }
        friend Polynomial& operator* (const R& lhs, Polynomial rhs) { return rhs *= lhs; }

        Polynomial operator- () const {
            auto negCoeffs = std::vector<R>(this->degree() + 1, R::Zero());
            for (int i = 0; i <= this->degree(); ++i) {
                negCoeffs[i] = -coeffs[i];
            }
            return Polynomial(negCoeffs);
        };
        */

        // important for monomials ordering
        friend bool operator<= (const Monomial& lhs, const Monomial& rhs) {
            return lhs.exponent <= rhs.exponent;
        }

        friend std::ostream& operator<< (std::ostream& os, const Monomial<R, dim>& p) {
            os << p.coefficient() << "*";
            os << "(";
            for (int i = 0; i <= dim; ++i) {
                os << p.exponent[i];
                if (i < p.degree())
                    os << ", ";
            }
            os << ")";
            return os;
        }
}

template<class R, unsigned int dim = 1>
class Polynomial : public RingEl<Polynomial<R, d>> {
    protected:
        std::list<Monomial<R, dim>> monomials;

    public:
}


#if 0

template<class R>
class Polynomial : public RingEl<Polynomial<R>> {
protected:
    const R coeffZero;

    std::vector<R> coeffs;
    int n;

public:
    Polynomial (std::initializer_list<R> coeffs) : n(coeffs.size() - 1), coeffs(coeffs), coeffZero(R::Zero()) {
        static_assert(std::is_base_of<RingEl<R>, R>::value, "Polynomial coefficient class must inherit from RingEl");
    }
    Polynomial (std::vector<R> coeffs) : n(coeffs.size() - 1), coeffs(coeffs), coeffZero(R::Zero()) {
        static_assert(std::is_base_of<RingEl<R>, R>::value, "Polynomial coefficient class must inherit from RingEl");
    };
    static Polynomial Monomial (const int k) {
        auto coeffs = std::vector<R>(k + 1, R::Zero());
        coeffs[k] = R::One();
        return Polynomial<R>(coeffs);
    }
    static Polynomial Zero () {
        return Polynomial<R>{};
    }
    static Polynomial One () {
        return Polynomial<R>::Monomial(0);
    }
    Polynomial& operator= (const Polynomial& rhs) { this->n = rhs.n; this->coeffs = rhs.coeffs; return *this; }

    const R& operator[] (int i) const {
        if (i < 0 || i > degree()) return coeffZero;
        return coeffs[i];
    }
    const int degree () const {
        return this->n;
    }
    const R& lead () const {
        return (*this)[this->degree()];
    }

    /* general ring properties */

    friend bool operator== (const Polynomial& lhs, const Polynomial& rhs) {
        return lhs.coeffs == rhs.coeffs;
    }
    //bool operator!= (const Polynomial& rhs) const { return !(*this == rhs); };

    Polynomial& operator+= (const Polynomial& rhs) {
        int maxDegree = std::max(this->degree(), rhs.degree());
        int newDegree = 0;
        coeffs.resize(maxDegree + 1, R::Zero());
        for (int i = 0; i <= maxDegree; ++i) {
            coeffs[i] += rhs[i];
            if (coeffs[i] != R::Zero()) newDegree = i;
        }
        coeffs.resize(newDegree + 1, R::Zero());
        n = newDegree;
        return *this;
    }

    Polynomial& operator-= (const Polynomial& rhs) {
        int maxDegree = std::max(this->degree(), rhs.degree());
        int newDegree = -1;
        coeffs.resize(maxDegree + 1, R::Zero());
        for (int i = 0; i <= maxDegree; ++i) {
            coeffs[i] -= rhs[i];
            if (coeffs[i] != R::Zero()) newDegree = i;
        }
        coeffs.resize(newDegree + 1, R::Zero());
        n = newDegree;
        return *this;
    }

    Polynomial& operator*= (const Polynomial& rhs) {
        /* TODO:
         * implement using DFT to achieve O(n*log n) complexity,
         * only possible with specific ring structures
         */

        if ((*this) == Polynomial<R>::Zero() || rhs == Polynomial<R>::Zero()) {
            (*this) = Polynomial<R>::Zero();
            return (*this);
        }


        int newDegree = this->degree() + rhs.degree();
        auto newCoeffs = std::vector<R>(newDegree + 1, R::Zero());

        //std::cout << (*this) << " //// " << rhs << std::endl;
        for (int i = 0; i <= newDegree; ++i) {
            //std::cout << "i = " << i << std::endl;

            for (int j = 0; j <= newDegree; ++j) {
                //std::cout << (*this)[j] << " * " << rhs[i-j] << std::endl;
                newCoeffs[i] += (*this)[j] * rhs[i-j];
            }
        }
        this->coeffs = newCoeffs;
        n = newDegree;
        return *this;
    }

    Polynomial& operator*= (const R& rhs) {
        int newDegree = 0;
        for (int i = 0; i <= this->degree(); ++i) {
            this->coeffs[i] *= rhs;
            if (coeffs[i] != R::Zero())
                newDegree = i;
        }
        this->n = newDegree;
        return *this;
    }
    friend Polynomial& operator* (Polynomial lhs, const R& rhs) { return lhs *= rhs; }
    friend Polynomial& operator* (const R& lhs, Polynomial rhs) { return rhs *= lhs; }

    Polynomial operator- () const {
        auto negCoeffs = std::vector<R>(this->degree() + 1, R::Zero());
        for (int i = 0; i <= this->degree(); ++i) {
            negCoeffs[i] = -coeffs[i];
        }
        return Polynomial(negCoeffs);
    };

    friend std::ostream& operator<< (std::ostream& os, const Polynomial<R>& p) {
        os << "⟦";
        for (int i = 0; i <= p.degree(); ++i) {
            //if (p[i] == R::Zero())
            //    continue;

            //os << "(" << p[i] << ") * X^" << i;
            os << p[i];
            if (i < p.degree())
                os << ", ";
        }
        os << "⟧";
        return os;
    }
};

#endif


#endif
