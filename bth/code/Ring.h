#ifndef RING_H
#define RING_H

#include <iostream>

template <class R>
class Ring {
  public:
    //Ring (Ring const &) = delete;
    //Ring & operator= (Ring const &) = delete;
    //virtual ~Ring();


    virtual bool operator== (const R &rhs) const = 0;
    virtual bool operator!= (const R &rhs) const { return !(*this == rhs); };

    virtual R & operator+= (const R& rhs) = 0;
    virtual R & operator-= (const R& rhs) = 0;
    virtual R & operator*= (const R& rhs) = 0;

    /*operator R & () { return static_cast<R &>(*this); };*/

    virtual R operator- () const = 0;
    //virtual R operator+ () const { return (*this); };

  protected:

    //Ring();
};

template <class R>
const R operator+ (R lhs, const R& rhs) { lhs += rhs; return lhs; }
template <class R>
const R operator- (R lhs, const R& rhs) { lhs -= rhs; return lhs; }
template <class R>
const R operator* (R lhs, const R& rhs) { lhs *= rhs; return lhs; }

#endif
