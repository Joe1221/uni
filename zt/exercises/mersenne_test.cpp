/* mersenne_test: Checks a Mersenne number for primality
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
 *    g++ -O3 -std=c++11 mersenne_test.cpp -o mersenne_test
 *
 * Run:
 *    ./mersenne_test <p>
 */

#include <iostream>
#include <cmath>

typedef unsigned long long int uint_64;

int main(int argc, char** argv) {
	if (argc < 2) {
		std::cout << "Usage: " << argv[0] << " <p>" << std::endl;
		return -1;
	}
	unsigned int p = std::stoull(argv[1]); // n, first argument passed
	uint_64 M_p = 1;
	M_p <<= p;
	M_p -= 1;

	std::cout << "Checking M_" << p << " = " << M_p << " for primality …" << std::endl;

	uint_64 s = 4;
	unsigned int k = 1;

	while (k < p - 1) {
		std::cout << "s_" << k << " = " << s << std::endl;
		s = s * s - 2;
		s %= M_p;
		k++;
	}
	std::cout << "s_" << k << " = " << s << std::endl;

	if (s == 0) {
		std::cout << "M_" << p << " is prime!" << std::endl;
	} else {
		std::cout << "M_" << p << " is NOT prime!" << std::endl;
	}

	return 0;
}

