#ifndef RATIONAL_H
#define RATIONAL_H

#include <gmpxx.h>
#include "RingEl.h"
#include "Order.h"

class Rational : public RingEl<Rational>, public Order<Rational> {
  protected:
    mpq_class val;
  public:

    /* standard interface */

    static Rational Zero() { return Rational(0,1); }
    static Rational One() { return Rational(1,1); }
    //Rational () : val(0) {};
    Rational (float val) : val(val) {};
    Rational (int n, int d) : val(n, d) {};
    Rational (mpq_class val) : val(val) {};

    Rational& operator= (const Rational& rhs) { this->val = rhs.val; return *this; }

    friend std::ostream& operator<< (std::ostream& os, const Rational& i) { return os << i.val; }


    /* general ring properties */

    friend bool operator== (const Rational& lhs, const Rational& rhs) { return lhs.val == rhs.val; }

    Rational& operator+= (const Rational& rhs) { this->val += rhs.val; return *this; }
    Rational& operator-= (const Rational& rhs) { this->val -= rhs.val; return *this; }
    Rational& operator*= (const Rational& rhs) { this->val *= rhs.val; return *this; }

    //const Rational&  operator+ () const { return *this; };
    Rational operator- () const { auto obj = Rational::Zero(); obj -= *this; return obj; };


    /* special integer properties */

    Rational&  operator++ () { ++this->val; return *this; }
    Rational operator++ (int) { auto tmp = *this; ++(*this); return tmp; }

    friend bool operator<= (const Rational& lhs, const Rational& other) { return lhs.val <= other.val; }

};


#endif
