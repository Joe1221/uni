cmake_minimum_required(VERSION 2.6)

set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules/")
set(CMAKE_CXX_FLAGS "--std=c++11")

project(AlgebraicMappingDegree)
add_executable(mytest test.cpp)
target_link_libraries(mytest gmp gmpxx)


include_directories(${GMP_INCLUDE_DIRS})
find_package(GMP REQUIRED)


