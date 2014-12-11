#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#include <gmpxx.h>

template<class R>
class Polynomial : public Ring<Polynomial<R>> {
  public:
    Polynomial (std::vector<R> coeffs) : coeffs(coeffs) {
        static_assert(std::is_base_of<Ring<R>, R>::value, "Polynomial coefficient class must inherit from Ring");
    };
    Polynomial& operator= (const Polynomial& rhs) { this->coeffs = rhs.coeffs; return *this; }

    bool operator== (const Polynomial& rhs) const { return this->coeffs == rhs.coeffs; }
    bool operator!= (const Polynomial& rhs) const { return !(*this == rhs); };

    Integer& operator+= (const Integer& rhs) { this->val += rhs.val; return *this; }
    Integer& operator-= (const Integer& rhs) { this->val -= rhs.val; return *this; }
    Integer& operator*= (const Integer& rhs) { this->val *= rhs.val; return *this; }

  protected:
    std::vector<R> coeffs;
};



#endif
