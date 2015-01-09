cmake_minimum_required(VERSION 3.0.0)

#set(CMAKE_CXX_FLAGS "-std=c++11")
add_compile_options(-std=c++11)
set(CMAKE_CXX_COMPILER "clang++")
set(EXT_PROJECTS_DIR "external")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules/")

project(bth-ramd)

# External
#=========

# GMP Dependency
include_directories(${GMP_INCLUDE_DIRS})
find_package(GMP REQUIRED)

# Catch Test Suite
add_subdirectory(${EXT_PROJECTS_DIR}/catch)
include_directories(${CATCH_INCLUDE_DIR} ${COMMON_INCLUDES})
enable_testing(true)

# Local
#========

# test suite
set(TESTS_SOURCES tests/main.cpp tests/integers.cpp tests/polynomial.cpp tests/binom.cpp tests/ramd.cpp tests/rational.cpp)
add_executable(tests ${TESTS_SOURCES})
target_link_libraries(tests gmp gmpxx)
add_dependencies(tests catch)

# main executable
set(MAIN_SOURCES test.cpp)
add_executable(mytest ${MAIN_SOURCES})
target_link_libraries(mytest gmp gmpxx)

