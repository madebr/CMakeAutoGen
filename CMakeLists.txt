# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>
# https://github.com/madebr/CMakeAutoGen

cmake_minimum_required(VERSION 2.8)
project(CMakeAutoGen)

include(CMakeModules/CMakeAutoGen.cmake)

enable_testing()
option(AUTOGEN_DEBUG "DEBUG AUTOGEN" 0)

add_subdirectory(test)
