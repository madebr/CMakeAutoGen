# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>

cmake_minimum_required(VERSION 2.8)
project(CMakeAutoGen)

include(CMakeModules/CMakeAutoGen.cmake)

enable_testing()
#set(AUTOGEN_DEBUG 1)

add_custom_target(FORCE_AUTOGEN)

function(force_build_autogen_target INPUT TARGETDIR)
    set(OUTPUTS "${ARGN}")
    add_autogen_target("${INPUT}" "${TARGETDIR}" ${OUTPUTS})
    add_custom_target("FORCE_${INPUT}" DEPENDS ${OUTPUTS})
    add_dependencies(FORCE_AUTOGEN "FORCE_${INPUT}")
    unset(REFERENCES)
    foreach(OUTPUT ${OUTPUTS})
        list(APPEND REFERENCES "${OUTPUT}.ref")
    endforeach()
    add_test(NAME "test_${INPUT}"
        COMMAND ${CMAKE_COMMAND} "-DOUTPUTS=${OUTPUTS}" "-DREFERENCES=${REFERENCES}" "-DREFDIR=${CMAKE_CURRENT_LIST_DIR}" -P "${PROJECT_SOURCE_DIR}/CMakeModules/CMakeDiffScript.cmake")
endfunction()

add_subdirectory(test)
