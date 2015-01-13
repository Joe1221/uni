#ifndef RINGEL_H
#define RINGEL_H

#include <iostream>

#include "SetEl.h"

template <class R>
class RingEl : SetEl<R> {
  public:
    //RingEl (RingEl const &) = delete;
    //RingEl & operator= (RingEl const &) = delete;
    //virtual ~RingEl();

    static R Zero ();
    static R One ();

    virtual R& operator+= (const R& rhs) = 0;
    virtual R& operator-= (const R& rhs) = 0;
    virtual R& operator*= (const R& rhs) = 0;

    /*operator R & () { return static_cast<R &>(*this); };*/
    friend const R operator+ (R lhs, const R& rhs) { lhs += rhs; return lhs; }
    friend const R operator- (R lhs, const R& rhs) { lhs -= rhs; return lhs; }
    friend const R operator* (R lhs, const R& rhs) { lhs *= rhs; return lhs; }

    virtual R operator- () const = 0;
    //virtual R operator+ () const { return (*this); };

  protected:

    //RingEl();
};

#endif
