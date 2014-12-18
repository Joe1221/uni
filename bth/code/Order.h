#ifndef ORDER_H
#define ORDER_H

#include "SetEl.h"

template<class T>
class Order : SetEl<T> {
  public:

    /* must be implemented */
    friend bool operator<= (const T& lhs, const T& rhs);

	/* granted for free */
    friend bool operator>= (const T& lhs, const T& other) { return other <= lhs; }
    friend bool operator< (const T& lhs, const T& other) { return (lhs <= other && lhs != other); }
    friend bool operator> (const T& lhs, const T& other) { return (lhs >= other && lhs != other); }
};


#endif
