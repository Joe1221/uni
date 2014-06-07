/* fermat_factor: Finds the smallest prime factor of a fermat number
 * Copyright (C) 2014 Stephan Hilb
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Compile:
 *    g++ -O3 -std=c++11 fermat_factor.cpp -o fermat_factor
 *
 * Run:
 *    ./fermat_factor <n>
 */

#include <iostream>

typedef unsigned long long int uint_64;

/*
 * Outputs a prime p + k*n with minimal k
 */
uint_64 next_prime_step_n (uint_64 p, uint_64 n)
{
	// check for primes in steps of n
	while (true) {
		p += n;

		// check for trivial non-primes
		if (p % 2 == 0 || p == 1)
			continue;

		// check for uneven divisors
		bool prime = true;
		for (uint_64 i = 3; i*i <= p; i += 2) {
			if (p % i == 0) {
				prime = false;
				break;
			}
		}

		if (prime)
			return p;
	}
}

/*
 * Print all primes less than m and equivalent 1 mod n
 */
void print_primes_1modn (uint_64 m, uint_64 n)
{
	uint_64 p = 1;
	while ((p = next_prime_step_n(p, n)) < m)
		std::cout << p << std::endl;
}

/*
 * Finds the smalles prime factor of F_n, where n is the first argument passed
 */
int main(int argc, char** argv) {
	if (argc < 2) {
		std::cout << "Usage: " << argv[0] << " <n>" << std::endl;
		return -1;
	}
	uint_64 n = std::stoull(argv[1]); // n, first argument passed

	uint_64 pmod = 1 << (n + 2); // = 2^(n+2)
	uint_64 p = 1;
	while (true) {
		// Generate primes in steps of nmod
		p = next_prime_step_n(p, pmod);
		std::cout << "p = " << p;

		// Construct F_n modulo p to avoid overflow
		uint_64 f = 1; // f = 2^0
		for (uint_64 i = 1; i <= 1 << n; i++) {
			f <<= 1; f %= p; // f = 2^i
		}
		f += 1;	f %= p; // f = 2^(2^n) + 1 = F_n

		// Divisibility check
		std::cout << ", F_" << n << " = " << f << " mod p" << std::endl;
		if (f == 0) {
			std::cout << "F_" << n << " has Primefactor: " << p << std::endl;
			break;
		}
	}
}

