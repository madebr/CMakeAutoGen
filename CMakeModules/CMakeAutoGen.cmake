# CMake implementation of AutoGen
# Copyright (C) 2017 Anonymous Maarten <anonymous.maarten@gmail.com>
# https://github.com/madebr/CMakeAutoGen

set(AUTOGEN_SCRIPT "${PROJECT_SOURCE_DIR}/CMakeModules/CMakeAutoGenScript.cmake")

function(autogen_get_depends INPUT OUTPUTDIR _DEPENDS)
    if (OUTPUTDIR)
        set(PREFIX "${OUTPUTDIR}/")
    else()
        set(PREFIX "")
    endif()

    execute_process(
        COMMAND "${CMAKE_COMMAND}" "-DACTION=DEPENDS" "-DDEFINITION=${CMAKE_CURRENT_SOURCE_DIR}/${INPUT}" -P "${AUTOGEN_SCRIPT}"
        OUTPUT_VARIABLE AUTOGEN_DEPENDS
    )
    string(STRIP "${AUTOGEN_DEPENDS}" AUTOGEN_DEPENDS)

    set("${_DEPENDS}" "${AUTOGEN_DEPENDS}" PARENT_SCOPE)
endfunction()

function(autogen_get_targets INPUT OUTPUTDIR _TARGETS)
    if (OUTPUTDIR)
        set(PREFIX "${OUTPUTDIR}/")
    else()
        set(PREFIX "")
    endif()

    execute_process(
        COMMAND "${CMAKE_COMMAND}" "-DACTION=TARGETS" "-DDEFINITION=${CMAKE_CURRENT_SOURCE_DIR}/${INPUT}" -P "${AUTOGEN_SCRIPT}"
        OUTPUT_VARIABLE AUTOGEN_TARGETS
    )
    string(STRIP "${AUTOGEN_TARGETS}" AUTOGEN_TARGETS)

    set("${_TARGETS}" "${AUTOGEN_TARGETS}" PARENT_SCOPE)
endfunction()

function(autogen_add_command INPUT OUTPUTDIR)
    autogen_get_depends("${INPUT}" "${OUTPUTDIR}" DEPENDS)
    autogen_get_targets("${INPUT}" "${OUTPUTDIR}" TARGETS)

    set(EXTRA_ARGS)
    if (AUTOGEN_DEBUG)
        list(APPEND EXTRA_ARGS "-DDEBUG=1")
    endif()
    if (OUTPUTDIR)
        list(APPEND EXTRA_ARGS "-DOUTPUTDIR=${OUTPUTDIR}")
    endif()

    add_custom_command(
        OUTPUT ${TARGETS}
        COMMAND "${CMAKE_COMMAND}" "-DACTION=TEMPLATE" "-DDEFINITION=${CMAKE_CURRENT_SOURCE_DIR}/${INPUT}" ${EXTRA_ARGS} -P "${AUTOGEN_SCRIPT}"
        MAIN_DEPENDENCY "${INPUT}"
        DEPENDS ${AUTOGEN_SCRIPT} ${DEPENDS}
        COMMENT "AutoGen: parsing ${INPUT}, generating ${TARGETS}"
    )
endfunction()
