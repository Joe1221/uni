#ifndef INTERVAL_H
#define INTERVAL_H

#include "Order.h"

template<class R>
class Interval {
    public:
        Interval () : a(0), b(0) {
            static_assert(std::is_base_of<RingEl<R>, R>::value,
                    "Coefficient class must inherit from RingEl");
            static_assert(std::is_base_of<Order<R>, R>::value,
                    "Coefficient class must inherit from Order");
        }
        Interval (R a, R b) : a(a), b(b) {
            static_assert(std::is_base_of<RingEl<R>, R>::value,
                    "Coefficient class must inherit from RingEl");
            static_assert(std::is_base_of<Order<R>, R>::value,
                    "Coefficient class must inherit from Order");
        }
        const R& left () const {
            return a;
        }
        const R& right () const {
            return b;
        }
        const bool contains (const R& c) const {
            return a <= c && c <= b;
        }
        friend std::ostream& operator<< (std::ostream& os, const Interval& interval) {
            return os << "[" << interval.left() << ", " << interval.right() << "]";
        }
    protected:
        R a;
        R b;
};


//template<class



#endif

