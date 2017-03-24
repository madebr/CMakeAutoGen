# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>

force_build_autogen_target(simple.def "" simple.out)
force_build_autogen_target(header_source.def "" header_source.c header_source.h)
force_build_autogen_target(quotes.def "" quotes.out)
