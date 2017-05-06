# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>
# https://github.com/madebr/CMakeAutoGen

define_property(GLOBAL
    PROPERTY ALL_GENERATED_SOURCES
    BRIEF_DOCS "List of all generated sources by CMAKEAutoGen"
    FULL_DOCS "These files are generated and compared with a reference in the test suite.")
set_property(GLOBAL PROPERTY ALL_GENERATED_SOURCES "")

function(force_build_autogen_target INPUT)
    set(OUTPUTS "${ARGN}")
    set(TARGETDIR "${CMAKE_CURRENT_BINARY_DIR}")
    add_autogen_target("${INPUT}" "${TARGETDIR}" ${OUTPUTS})
    unset(REFERENCES)
    foreach(OUTPUT ${OUTPUTS})
        list(APPEND REFERENCES "${OUTPUT}.ref")
        set_property(GLOBAL APPEND PROPERTY ALL_GENERATED_SOURCES "${TARGETDIR}/${OUTPUT}")
    endforeach()
    add_test(NAME "test_${INPUT}"
        COMMAND ${CMAKE_COMMAND} "-DOUTPUTS=${OUTPUTS}" "-DREFERENCES=${REFERENCES}" "-DREFDIR=${CMAKE_CURRENT_LIST_DIR}" -P "${PROJECT_SOURCE_DIR}/CMakeModules/CMakeDiffScript.cmake")
endfunction()

force_build_autogen_target(simple.def simple.out)
force_build_autogen_target(case_suffix.def case_suffix.out1 case_suffix.out2)
force_build_autogen_target(quotes.def quotes.out)
force_build_autogen_target(math.def math.out)
force_build_autogen_target(linenumber.def linenumber.out)

get_property(TEST_SOURCES GLOBAL PROPERTY ALL_GENERATED_SOURCES)

add_custom_target(test_sources
    ALL
    DEPENDS ${TEST_SOURCES}
)

