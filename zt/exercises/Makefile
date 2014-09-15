CXX ?= g++
CXXFLAGS ?= -O3 -std=c++11

CPP_FILES = $(wildcard *.cpp)
OBJ_FILES = $(patsubst %.cpp,%.o,$(CPP_FILES))

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $<

all: fermat_factor mersenne_test

fermat_factor: fermat_factor.o
	$(CXX) $(CXXFLAGS) -o $@ $^
mersenne_test: mersenne_test.o
	$(CXX) $(CXXFLAGS) -o $@ $^

clean:
	rm -f $(OBJ_FILES) fermat_factor mersenne_test

