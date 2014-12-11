#ifndef INTEGER_H
#define INTEGER_H

#include <gmpxx.h>
#include "Ring.h"

class Integer : public Ring<Integer> {
  public:
    Integer (int val) : val(val) {};
    Integer&  operator= (const Integer& rhs) { this->val = rhs.val; return *this; }

    /* general ring properties */

    bool operator== (const Integer& rhs) const { return this->val == rhs.val; }
    bool operator!= (const Integer& rhs) const { return !(*this == rhs); };

    Integer& operator+= (const Integer& rhs) { this->val += rhs.val; return *this; }
    Integer& operator-= (const Integer& rhs) { this->val -= rhs.val; return *this; }
    Integer& operator*= (const Integer& rhs) { this->val *= rhs.val; return *this; }

    //const Integer&  operator+ () const { return *this; };
    Integer operator- () const { auto obj = Integer(0); obj -= *this; return obj; };

    /* special integer properties */

    Integer&  operator++ () { ++this->val; return *this; }
    Integer operator++ (int) { auto tmp = *this; ++(*this); return tmp; }

    bool operator< (const Integer& other) const { return this->val < other.val; }
    bool operator<= (const Integer& other) const { return this->val <= other.val; }
    bool operator> (const Integer& other) const { return this->val > other.val; }
    bool operator>= (const Integer& other) const { return this->val >= other.val; }

    friend std::ostream& operator<< (std::ostream& os, const Integer& i) { return os << i.val; }

  protected:
    mpz_class val;
};


Integer operator+ (Integer lhs, const Integer& rhs) { lhs += rhs; return lhs; }
Integer operator- (Integer lhs, const Integer& rhs) { lhs -= rhs; return lhs; }
Integer operator* (Integer lhs, const Integer& rhs) { lhs *= rhs; return lhs; }


#endif
