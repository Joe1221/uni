#ifndef INTEGER_H
#define INTEGER_H

#include <gmpxx.h>
#include "RingEl.h"
#include "Order.h"
#include "Rational.h"

class Integer : public RingEl<Integer>, public Order<Integer> {
  protected:
    mpz_class val;
  public:

    /* standard interface */

    static Integer Zero() { return Integer(0); }
    static Integer One() { return Integer(1); }
    Integer () : val(0) {};
    Integer (int val) : val(val) {};

    operator Rational () const {
        return Rational(mpz_class(val));
    }

    Integer&  operator= (const Integer& rhs) { this->val = rhs.val; return *this; }

    friend std::ostream& operator<< (std::ostream& os, const Integer& i) { return os << i.val; }


    /* general ring properties */

    friend bool operator== (const Integer& lhs, const Integer& rhs) { return lhs.val == rhs.val; }

    Integer& operator+= (const Integer& rhs) { this->val += rhs.val; return *this; }
    Integer& operator-= (const Integer& rhs) { this->val -= rhs.val; return *this; }
    Integer& operator*= (const Integer& rhs) { this->val *= rhs.val; return *this; }

    //const Integer&  operator+ () const { return *this; };
    Integer operator- () const { auto obj = Integer::Zero(); obj -= *this; return obj; };


    /* special integer properties */

    Integer&  operator++ () { ++this->val; return *this; }
    Integer operator++ (int) { auto tmp = *this; ++(*this); return tmp; }

    friend bool operator<= (const Integer& lhs, const Integer& other) { return lhs.val <= other.val; }
};


#endif
