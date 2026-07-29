cmake_minimum_required(VERSION 3.18)

project(test-apple2 LANGUAGES C)

include(../test.cmake)

add_subdirectory(compile)
add_subdirectory(no-compile)
