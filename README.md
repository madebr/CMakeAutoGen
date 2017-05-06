# AutoGen for CMake

[![Build Status](https://travis-ci.org/madebr/CMakeAutoGen.svg?branch=master)](https://travis-ci.org/madebr/CMakeAutoGen)

This repository provides a pure CMake implementation of the template engine of [GNU AutoGen](https://www.gnu.org/software/autogen/).

## Important files

Using CMakeAutoGen is very easy. Just copy `CMakeAutoGen.cmake` and `CMakeAutoGenScript.cmake` in your project and include CMakeAutoGen.cmake.

- [`CMakeAutoGen.cmake`](https://github.com/madebr/CMakeAutoGen/blob/master/CMakeModules/CMakeAutoGen.cmake):
  - contains `add_custom_command` for inclusion in your project
  - you might have to write a wrapper function around `add_autogen_target`.
- [`CMakeAutoGenScript.cmake`](https://github.com/madebr/CMakeAutoGen/blob/master/CMakeModules/CMakeAutoGenScript.cmake):
  - does the heavy lifting
  - is executed as a script by `add_autogen_target`

## But why?

Using a CMake implementation of AutoGen instead of the AutoGen executable itself, allows a project to not require the autotools toolchain to be present.
This is most useful on Windows platforms.

## License

GPLv3 (See `License`)
