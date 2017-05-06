# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>
# https://github.com/madebr/CMakeAutoGen

force_build_autogen_target(simple.def "" simple.out)
force_build_autogen_target(case_suffix.def "" case_suffix.out1 case_suffix.out2)
force_build_autogen_target(quotes.def "" quotes.out)
force_build_autogen_target(math.def "" math.out)
force_build_autogen_target(linenumber.def "" linenumber.out)
