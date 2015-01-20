#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#include <initializer_list>
#include <array>
#include <iterator>
#include <list>
#include <gmpxx.h>

#include "RingEl.h"
#include "Order.h"
#include "math.h"

// should be private to Polynomial
template<class R, unsigned int dim = 1>
class Monomial : public SetEl<Monomial<R, dim>>, public Order<Monomial<R, dim>> {
    protected:
        R _coefficient;
        std::array<unsigned int, dim> _exponents;
    public:
        /*Monomial (R coefficient == R::One(), std::initalizer_list<unsigned int> exponents)
                : exponents(exponents), coefficient(coefficient) {
            // assert(exponents.size() == d) ?
        }*/
        Monomial (R coefficient, std::array<unsigned int, dim> exponents)
                : _exponents(exponents), _coefficient(coefficient) { }

        /*Monomial (R coefficient, std::initializer_list<unsigned int> exponents)
                : _exponents(exponents), _coefficient(coefficient) { }*/

        //Monomial& operator= (const Monomial& rhs) { /* */ return *this; }

        const int totalDegree () const {
            int d = 0;
            for (unsigned int i = 0; i < dim; ++i) {
                d += exponent(i);
            }
            return d;
        }

        const unsigned int exponent (unsigned int i) const {
            return this->_exponents.at(i);
        }

        const std::array<unsigned int, dim>& exponents () const {
            return this->_exponents;
        }

        const R& coefficient () const {
            return this->_coefficient;
        }

        const R& coefficient (const R& c) {
            return this->_coefficient = c;
        }

        // SetEl, equality, != for free
        friend bool operator== (const Monomial& lhs, const Monomial& rhs) {
            return lhs._coefficient == rhs._coefficient && lhs._exponents == rhs._exponents;
        }

        Monomial& operator*= (const Monomial& rhs) {
            this->_coefficient *= rhs.coefficient();
            for (unsigned int i = 0; i < dim; ++i) {
                this->_exponents[i] += rhs.exponent(i);
            }
            return *this;
        }
        friend const Monomial operator* (Monomial lhs, const Monomial& rhs) { lhs *= rhs; return lhs; }

        Monomial<R, dim>& operator*= (const Monomial<R, dim - 1>& rhs) {
            this->_coefficient *= rhs.coefficient();
            for (unsigned int i = 1; i < dim; ++i) {
                this->_exponents[i] += rhs.exponent(i - 1);
            }
            return *this;
        }
        friend const Monomial<R, dim> operator* (Monomial<R, dim> lhs, const Monomial<R, dim - 1>& rhs) { return lhs *= rhs; }
        friend const Monomial<R, dim> operator* (const Monomial<R, dim - 1>& lhs, Monomial<R, dim> rhs) { return rhs *= lhs; }

        Monomial& operator*= (const R& rhs) {
            this->_coefficient *= rhs;
            return *this;
        }
        friend const Monomial operator* (Monomial lhs, const R& rhs) { return lhs *= rhs; }
        friend const Monomial operator* (const R& lhs, Monomial rhs) { return rhs *= lhs; }

        Monomial operator- () const {
            return Monomial(-(this->_coefficient), this->_exponents);
        };

        // important for monomials ordering
        friend bool operator<= (const Monomial& lhs, const Monomial& rhs) {
            return lhs._exponents <= rhs._exponents;
        }

        friend std::ostream& operator<< (std::ostream& os, const Monomial<R, dim>& p) {
            os << p.coefficient() << "*";
            os << "(";
            for (int i = 0; i < dim; ++i) {
                os << p.exponent(i);
                if (i < dim - 1)
                    os << ", ";
            }
            os << ")";
            return os;
        }
};

template<class R, unsigned int dim = 1>
class Polynomial : public RingEl<Polynomial<R, dim>> {
    protected:
        std::list<Monomial<R, dim>> _monomials;

        void sort () {
            _monomials.sort();
        }
        void normalize () {
            auto it_first = _monomials.begin();
            for (auto it_second = std::next(it_first); it_second != _monomials.end();) {
                if (it_first->exponents() != it_second->exponents()) {
                    ++it_first;
                    ++it_second;
                } else {
                    it_first->coefficient(it_first->coefficient() + it_second->coefficient());
                    it_second = _monomials.erase(it_second);
                }
            }
            for (auto it = _monomials.begin(); it != _monomials.end(); ++it) {
                if (it->coefficient() == R::Zero()) {
                    it = std::prev(_monomials.erase(it));
                }
            }
        }

    public:

        static Polynomial<R, dim> Zero () {
            std::list<Monomial<R, dim>> monomials;
            return Polynomial<R, dim>(monomials);
        }

        static Polynomial<R, dim> One () {
            std::list<Monomial<R, dim>> monomials;
            std::array<unsigned int, dim> exponents;
            exponents.fill(0);
            monomials.push_back(Monomial<R, dim>(R::One(), exponents));
            return Polynomial<R, dim>(monomials);
        }

        Polynomial (std::initializer_list<R> coefficients) {
            static_assert(std::is_base_of<RingEl<R>, R>::value, "Polynomial coefficient class must inherit from RingEl");

            unsigned int exponent = 0;
            for (auto it = coefficients.begin(); it != coefficients.end(); ++it, ++exponent) {
                std::array<unsigned int, dim> exponents;
                exponents[0] = exponent;
                this->_monomials.push_back(Monomial<R, dim>(*it, exponents));
            }
            sort();
            normalize();
        }
        Polynomial (std::list<Monomial<R, dim>> monomials) : _monomials(monomials) {
            sort();
            normalize();
        }
        Polynomial () {
            *this = Polynomial<R, dim>::Zero();
        }

        static Polynomial Monom(unsigned int k, unsigned int j = 0) {
            std::array<unsigned int, dim> exponents;
            exponents[j] = k;
            Monomial<R, dim> monomial(R::One(), exponents);
            std::list<Monomial<R, dim>> monomials = { monomial };
            return Polynomial<R, dim>(monomials);
        }

        const std::list<Monomial<R, dim>>& monomials () const {
            return _monomials;
        }

        // TODO: Should be calculated e.g. in normalize() (one loop is enough to
        // compute all degrees) and cached
        const int degree (unsigned int j = 0) const {
            int d = 0;
            for (auto& m : _monomials) {
                int e = m.exponent(j);
                if (e > d)
                    d = e;
            }
            return d;
        }

        const int totalDegree () const {
            int d = 0;
            for (auto& m : _monomials) {
                int e = m.totalDegree();
                if (e > d)
                    d = e;
            }
            return d;
        }

        const R constCoefficient () {
            return _monomials.front().coefficient();
        }

        const Polynomial<R, dim - 1> coefficient (int k, int j = 0) {
            int d = degree(j);
            if (k < 0 || k > d) return Polynomial<R, dim - 1>::Zero();

            std::list<Monomial<R, dim - 1>> coeff_monomials;
            for (auto& monomial : _monomials) {
                if (monomial.exponent(j) != k)
                    continue;
                auto m_exponents = monomial.exponents();
                std::array<unsigned int, dim - 1> cm_exponents;
                std::copy(std::begin(m_exponents), std::next(std::begin(m_exponents), j), std::begin(cm_exponents));
                std::copy(std::next(std::begin(m_exponents), j + 1), std::end(m_exponents), std::next(std::begin(cm_exponents), j));

                coeff_monomials.push_back(Monomial<R, dim - 1>(monomial.coefficient(), cm_exponents));

            }
            Polynomial<R, dim - 1> coeff(coeff_monomials);
            return coeff;
        }


        const Polynomial<R, dim - 1> lead (unsigned int j = 0) {
            return coefficient(degree(j), j);
        }

        // TODO: allow other evaluation domains
        Polynomial<R, dim - 1> stable_eval (R a, int j = 0) {
            int n = degree(j);
            for (int k = 0; k <= n; ++k) {
                Polynomial<R, dim - 1> c = Polynomial<R, dim - 1>::Zero();
                for (int l = k; l <= n; ++l) {
                    c += binom(l, k) * coefficient(l, j) * pow(a, l - k);
                }

                if (c == Polynomial<R, dim - 1>::Zero())
                    continue;

                if ((k & 1) == 0) {
                    return c;
                } else {
                    return Polynomial<R, dim - 1>::Zero();
                }
            }
            return Polynomial<R, dim - 1>::Zero();
        }

        friend bool operator== (const Polynomial& lhs, const Polynomial& rhs) {
            return lhs._monomials == rhs._monomials;
        }

        Polynomial& operator+= (const Polynomial& rhs) {
            auto rhs_monomials = rhs.monomials();
            _monomials.merge(rhs_monomials);
            normalize();
            return *this;
        }

        Polynomial& operator-= (const Polynomial& rhs) {
            return (*this) += -rhs;
        }

        Polynomial& operator*= (const Polynomial& rhs) {
            std::list<Monomial<R, dim>> monomials_new;
            for (auto& m : _monomials) {
                for (auto& n : rhs.monomials()) {
                    monomials_new.push_back(m * n);
                }
            }
            _monomials = std::move(monomials_new);
            sort();
            normalize();
            return *this;
        }

        // Important for multiplication with polynomial coefficients
        Polynomial<R, dim>& operator*= (const Polynomial<R, dim - 1>& rhs) {
            std::list<Monomial<R, dim>> monomials_new;
            for (auto& m : _monomials) {
                for (auto& n : rhs.monomials()) {
                    monomials_new.push_back(m * n);
                }
            }
            _monomials = std::move(monomials_new);
            sort();
            normalize();
            return *this;
        }
        friend const Polynomial<R, dim> operator* (Polynomial<R, dim> lhs, const Polynomial<R, dim - 1>& rhs) { return lhs *= rhs; }
        friend const Polynomial<R, dim> operator* (const Polynomial<R, dim - 1>& lhs, Polynomial<R, dim> rhs) { return rhs *= lhs; }

        Polynomial& operator*= (const R& rhs) {
            for (auto& monomial : _monomials) {
                monomial *= rhs;
            }
            return *this;
        }
        friend const Polynomial operator* (Polynomial lhs, const R& rhs) { return lhs *= rhs; }
        friend const Polynomial operator* (const R& lhs, Polynomial rhs) { return rhs *= lhs; }

        Polynomial operator- () const {
            auto monomials = _monomials;
            for (auto& m : monomials) {
                m = -m;
            }
            return Polynomial(monomials);
        }
/*
    private:
        template<unsigned int dim2>
        typename std::enable_if<dim2 == 0, R>::type coeffcast () const {
            return _monomials.front().coefficient();
        }
    public:*/
        template<unsigned int dim2 = dim>
        operator typename std::enable_if<dim2 == 0, R>::type() const {
            return _monomials.front().coefficient();
        }

        friend std::ostream& operator<< (std::ostream& os, const Polynomial<R, dim>& p) {
            os << "⟦";
            auto& ms = p._monomials;
            for (auto it = ms.begin(); it != ms.end(); ++it) {
                if (it != ms.begin())
                    os << " + ";
                os << *it;
            }
            os << "⟧";
            return os;
        }
};

/*
template<class R>
const Polynomial<R, 0> Polynomial<R, 0>::coefficient<1> (int k) {
    return Polynomial<R, 0>::Zero();
}
*/
/*
template<R>
Integer::Integer(Polynomial<R, 0> p) {
    p.coefficient()
}*/

/*
template<class R>
class Polynomial<R, 1> : public RingEl<Polynomial<R, 1>> {
    protected:
        std::list<Monomial<R, dim>> _monomials;

        void sort () {
            _monomials.sort();
        }
        void normalize () {
            auto it_old = _monomials.begin();
            for (auto it = std::next(it_old); it != _monomials.end(); ++it_old, ++it) {
                if (it_old->exponents() == it->exponents()) {
                    Monomial<R, dim> m(it_old->coefficient() + it->coefficient(), it->exponents());
                    _monomials.erase(it_old);
                    auto it_old = _monomials.insert(it, m);
                    it = _monomials.erase(it);
                }
            }
            for (auto it = _monomials.begin(); it != _monomials.end(); ++it) {
                if (it->coefficient() == R::Zero()) {
                    it = std::prev(_monomials.erase(it));
                }
            }
        }

    public:

        Polynomial (std::initializer_list<R> coefficients) {
            static_assert(std::is_base_of<RingEl<R>, R>::value, "Polynomial coefficient class must inherit from RingEl");

            unsigned int exponent = 0;
            for (auto it = coefficients.begin(); it != coefficients.end(); ++it) {
                std::array<unsigned int, dim> exponents;
                exponents[0] = exponent;
                this->_monomials.push_back(Monomial<R, dim>(*it, exponents));
            }
        }
        Polynomial (std::list<Monomial<R, dim>> monomials) : _monomials(monomials) {
            sort();
            normalize();
        }

        const std::list<Monomial<R, dim>>& monomials () const {
            return _monomials;
        }

        template<unsigned int K = 0>
        const int degree () const {
            int d = 0;
            for (auto& m : _monomials) {
                int e = m.exponent(K);
                if (e > d)
                    d = e;
            }
        }

        template<unsigned int j = 0>
        const Polynomial<R, dim - 1> coefficient (int k) {
            int d = degree<j>();
            if (k < 0 || k > d) return Polynomial<R, dim - 1>::Zero();

            std::list<Monomial<R, dim - 1>> coeff_monomials;
            for (auto& monomial : _monomials) {
                if (monomial.exponent(j) != k)
                    continue;
                auto m_exponents = monomial.exponents();
                std::array<unsigned int, dim - 1> cm_exponents;
                std::copy(std::begin(m_exponents), std::next(std::begin(m_exponents), j), std::begin(cm_exponents));
                std::copy(std::next(std::begin(m_exponents), j + 1), std::end(m_exponents), std::next(std::begin(cm_exponents), j));

                coeff_monomials.push_back(Monomial<R, dim - 1>(monomial.coefficient(), cm_exponents));

            }
            Polynomial<R, dim - 1> coeff(coeff_monomials);
            return coeff;
        }

        template<unsigned int j = 0>
        const Polynomial<R, dim - 1> lead () {
            int k = 0;
            for (auto& monomial : _monomials) {
                auto l = monomial.exponent(j);
                if (l > k)
                    k = l;
            }
            return coefficient(k);
        }

        Polynomial& operator+= (const Polynomial& rhs) {
            auto rhs_monomials = rhs.monomials();
            _monomials.merge(rhs_monomials);
            normalize();
            return *this;
        }

        Polynomial& operator-= (const Polynomial& rhs) {
            return (*this) += -rhs;
        }

        Polynomial& operator*= (const Polynomial& rhs) {
            std::list<Monomial<R, dim>> monomials_new;
            for (auto& m : _monomials) {
                for (auto& n : rhs.monomials()) {
                    monomials_new.push_back(m * n);
                }
            }
            sort();
            normalize();
            return *this;
        }

        Polynomial operator- () const {
            auto monomials = _monomials;
            for (auto& m : monomials) {
                m = -m;
            }
            return Polynomial(monomials);
        }


        friend std::ostream& operator<< (std::ostream& os, const Polynomial<R, dim>& p) {
            auto& ms = p._monomials;
            for (auto it = ms.begin(); it != ms.end(); ++it) {
                if (it != ms.begin())
                    os << " + ";
                os << *it;
            }
            os << ")";
            return os;
        }
};
















*/

/*
template<class R>
class Polynomial<R, 1> : Polynomial<R, 1> {
    public:
};
*/

#if 0

template<class R>
class Polynomial : public RingEl<Polynomial<R>> {
protected:
    const R coeffZero;

    std::vector<R> coeffs;
    int n;

public:
    Polynomial (std::initializer_list<R> coeffs) : n(coeffs.size() - 1), coeffs(coeffs), coeffZero(R::Zero()) {
        static_assert(std::is_base_of<RingEl<R>, R>::value, "Polynomial coefficient class must inherit from RingEl");
    }
    Polynomial (std::vector<R> coeffs) : n(coeffs.size() - 1), coeffs(coeffs), coeffZero(R::Zero()) {
        static_assert(std::is_base_of<RingEl<R>, R>::value, "Polynomial coefficient class must inherit from RingEl");
    };
    static Polynomial Monomial (const int k) {
        auto coeffs = std::vector<R>(k + 1, R::Zero());
        coeffs[k] = R::One();
        return Polynomial<R>(coeffs);
    }
    static Polynomial Zero () {
        return Polynomial<R>{};
    }
    static Polynomial One () {
        return Polynomial<R>::Monomial(0);
    }
    Polynomial& operator= (const Polynomial& rhs) { this->n = rhs.n; this->coeffs = rhs.coeffs; return *this; }

    const R& operator[] (int i) const {
        if (i < 0 || i > degree()) return coeffZero;
        return coeffs[i];
    }
    const int degree () const {
        return this->n;
    }
    const R& lead () const {
        return (*this)[this->degree()];
    }

    /* general ring properties */

    friend bool operator== (const Polynomial& lhs, const Polynomial& rhs) {
        return lhs.coeffs == rhs.coeffs;
    }
    //bool operator!= (const Polynomial& rhs) const { return !(*this == rhs); };

    Polynomial& operator+= (const Polynomial& rhs) {
        int maxDegree = std::max(this->degree(), rhs.degree());
        int newDegree = 0;
        coeffs.resize(maxDegree + 1, R::Zero());
        for (int i = 0; i <= maxDegree; ++i) {
            coeffs[i] += rhs[i];
            if (coeffs[i] != R::Zero()) newDegree = i;
        }
        coeffs.resize(newDegree + 1, R::Zero());
        n = newDegree;
        return *this;
    }

    Polynomial& operator-= (const Polynomial& rhs) {
        int maxDegree = std::max(this->degree(), rhs.degree());
        int newDegree = -1;
        coeffs.resize(maxDegree + 1, R::Zero());
        for (int i = 0; i <= maxDegree; ++i) {
            coeffs[i] -= rhs[i];
            if (coeffs[i] != R::Zero()) newDegree = i;
        }
        coeffs.resize(newDegree + 1, R::Zero());
        n = newDegree;
        return *this;
    }

    Polynomial& operator*= (const Polynomial& rhs) {
        /* TODO:
         * implement using DFT to achieve O(n*log n) complexity,
         * only possible with specific ring structures
         */

        if ((*this) == Polynomial<R>::Zero() || rhs == Polynomial<R>::Zero()) {
            (*this) = Polynomial<R>::Zero();
            return (*this);
        }


        int newDegree = this->degree() + rhs.degree();
        auto newCoeffs = std::vector<R>(newDegree + 1, R::Zero());

        //std::cout << (*this) << " //// " << rhs << std::endl;
        for (int i = 0; i <= newDegree; ++i) {
            //std::cout << "i = " << i << std::endl;

            for (int j = 0; j <= newDegree; ++j) {
                //std::cout << (*this)[j] << " * " << rhs[i-j] << std::endl;
                newCoeffs[i] += (*this)[j] * rhs[i-j];
            }
        }
        this->coeffs = newCoeffs;
        n = newDegree;
        return *this;
    }

    Polynomial& operator*= (const R& rhs) {
        int newDegree = 0;
        for (int i = 0; i <= this->degree(); ++i) {
            this->coeffs[i] *= rhs;
            if (coeffs[i] != R::Zero())
                newDegree = i;
        }
        this->n = newDegree;
        return *this;
    }
    friend Polynomial& operator* (Polynomial lhs, const R& rhs) { return lhs *= rhs; }
    friend Polynomial& operator* (const R& lhs, Polynomial rhs) { return rhs *= lhs; }

    Polynomial operator- () const {
        auto negCoeffs = std::vector<R>(this->degree() + 1, R::Zero());
        for (int i = 0; i <= this->degree(); ++i) {
            negCoeffs[i] = -coeffs[i];
        }
        return Polynomial(negCoeffs);
    };

    friend std::ostream& operator<< (std::ostream& os, const Polynomial<R>& p) {
        os << "⟦";
        for (int i = 0; i <= p.degree(); ++i) {
            //if (p[i] == R::Zero())
            //    continue;

            //os << "(" << p[i] << ") * X^" << i;
            os << p[i];
            if (i < p.degree())
                os << ", ";
        }
        os << "⟧";
        return os;
    }
};

#endif


#endif
