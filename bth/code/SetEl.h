#ifndef SETEL_H
#define SETEL_H

template<class T>
class SetEl {
  public:

    /* must be implemented */
    friend bool operator== (const T& lhs, const T& rhs);

	/* granted for free */
    friend bool operator!= (const T& lhs, const T& rhs) { return !(lhs == rhs); }
};


#endif
