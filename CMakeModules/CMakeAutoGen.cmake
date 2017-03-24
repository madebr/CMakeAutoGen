# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>

function(add_autogen_target INPUT)
    set(OUTPUT "${ARGN}")

    set(EXTRA_ARGS)
    if (AUTOGEN_DEBUG)
        list(APPEND EXTRA_ARGS
            "-DDEBUG=1"
        )
    endif()

    add_custom_command(
        OUTPUT ${OUTPUT}
        COMMAND ${CMAKE_COMMAND} "-DDEFINITION=${CMAKE_CURRENT_SOURCE_DIR}/${INPUT}" ${EXTRA_ARGS} -P "${PROJECT_SOURCE_DIR}/CMakeModules/CMakeAutoGenScript.cmake"
        MAIN_DEPENDENCY "${INPUT}"
        COMMENT "AutoGen: parsing ${INPUT}, generating ${OUTPUT}"
    )
endfunction()
