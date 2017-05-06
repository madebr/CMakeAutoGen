# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>
# https://github.com/madebr/CMakeAutoGen

if ("${REFERENCES}" STREQUAL "")
    message(FATAL_ERROR "Need REFERENCES")
endif()
if ("${OUTPUTS}" STREQUAL "")
    message(FATAL_ERROR "Need OUTPUTS")
endif()

list(LENGTH REFERENCES REFERENCES_LENGTH)
list(LENGTH OUTPUTS OUTPUTS_LENGTH)

if (NOT "${REFERENCES_LENGTH}" EQUAL "${OUTPUTS_LENGTH}")
    message(FATAL_ERROR "REFERENCES and OUTPUTS must have equal length (${REFERENCES_LENGTH} and ${OUTPUTS_LENGTH})")
endif()

math(EXPR INDEX_MAX "${REFERENCES_LENGTH}-1")

foreach(INDEX RANGE 0 ${INDEX_MAX} 1)
    list(GET REFERENCES ${INDEX} REFERENCE)
    list(GET OUTPUTS ${INDEX} OUTPUT)
    get_filename_component(REFERENCE_NAME "${REFERENCE}" NAME)
    if (NOT "${REFDIR}" STREQUAL "")
        set(REFERENCE_NAME "${REFDIR}/${REFERENCE_NAME}")
    endif()
    file(READ "${REFERENCE_NAME}" REFERENCE_CONTENTS)
    file(READ "${OUTPUT}" OUTPUT_CONTENTS)
    if ("${REFERENCE_CONTENTS}" STREQUAL "${OUTPUT_CONTENTS}")
        message("NO DIFF: ${REFERENCE} and ${OUTPUT}")
    else()
        message(FATAL_ERROR "${REFERENCE} and ${OUTPUT} differ")
    endif()
endforeach()
