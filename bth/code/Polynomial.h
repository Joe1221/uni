#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#include <initializer_list>
#include <gmpxx.h>

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
    Polynomial& operator= (const Polynomial& rhs) { this->n = rhs.n; this->coeffs = rhs.coeffs; return *this; }

    const R& operator[] (int i) const {
        if (i < 0 || i > degree()) return coeffZero;
        return coeffs[i];
    }
    const int degree () const {
        return this->n;
    }

    /* general ring properties */

    bool operator== (const Polynomial& rhs) const { return this->coeffs == rhs.coeffs; }
    bool operator!= (const Polynomial& rhs) const { return !(*this == rhs); };

    Polynomial& operator+= (const Polynomial& rhs) {
        int maxDegree = std::max(this->degree(), rhs.degree());
        int newDegree = 0;
        coeffs.resize(maxDegree + 1);
        for (int i = 0; i <= maxDegree; ++i) {
            coeffs[i] += rhs[i];
            if (coeffs[i] != R::Zero()) newDegree = i;
        }
        coeffs.resize(newDegree + 1);
        n = newDegree;
        return *this;
    }

    Polynomial& operator-= (const Polynomial& rhs) {
        int maxDegree = std::max(this->degree(), rhs.degree());
        int newDegree = 0;
        coeffs.resize(maxDegree + 1);
        for (int i = 0; i <= maxDegree; ++i) {
            coeffs[i] -= rhs[i];
            if (coeffs[i] != R::Zero()) newDegree = i;
        }
        coeffs.resize(newDegree + 1);
        n = newDegree;
        return *this;
    }

    Polynomial& operator*= (const Polynomial& rhs) {
        /* TODO:
         * implement using DFT to achieve O(n*log n) complexity,
         * only possible with specific ring structures
         */
        int newDegree = this->degree() + rhs.degree();
        auto newCoeffs = std::vector<R>(newDegree + 1);

        for (int i = 0; i <= newDegree; ++i) {
            for (int j = 0; j <= newDegree; ++j) {
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
        auto negCoeffs = std::vector<R>(this->degree() + 1);
        for (int i = 0; i <= this->degree(); ++i) {
            negCoeffs[i] = -coeffs[i];
        }
        return Polynomial(negCoeffs);
    };

    friend std::ostream& operator<< (std::ostream& os, const Polynomial<R>& p) {
        for (int i = p.degree(); i >= 0; --i) {
            if (p[i] == R::Zero())
                continue;
            if (i < p.degree())
                os << " + ";
            //os << "(" << p[i] << ") * X^" << i;
            os << "(" << p[i] << ")" << "*X^" << i;
        }
        return os;
    }
};



#endif
