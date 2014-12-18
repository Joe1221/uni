#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#include <gmpxx.h>

template<class R>
class Polynomial : public RingEl<Polynomial<R>> {
  public:
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
      int maxDegree = std::max(this->n, rhs.degree());
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
      int maxDegree = std::max(this->n, rhs.degree());
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
      int newDegree = this->n + rhs.degree();
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

    Polynomial operator- () const {
      auto negCoeffs = std::vector<R>(this->n);
      for (int i = 0; i <= this->n; ++i) {
        negCoeffs[i] = -coeffs[i];
      }
      return Polynomial(negCoeffs);
    };

    friend std::ostream& operator<< (std::ostream& os, const Polynomial<R>& p) {
      for (int i = p.degree(); i >= 0; --i) {
        if (p[i] != R::Zero()) {
          if (i < p.degree()) os << " + ";
          //os << "(" << p[i] << ") * X^" << i;
          os << p[i] << "*X^" << i;
        }
      }
      return os;
    }

  protected:
    const R coeffZero;

    std::vector<R> coeffs;
    int n;
};



#endif
